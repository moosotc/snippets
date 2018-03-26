#!/usr/bin/env python
# -*- coding: utf-8 -*-

import time, os, sys, select, signal, subprocess
import socket, ssl, re, json

HOST = "imap.gmail.com"
PORT = 993
HOST = socket.getaddrinfo (HOST, PORT)[0][4][0]
email = b"moosotc@gmail.com"

prevunseen = 0
prevt = 0

# http://stackoverflow.com/questions/20794414/how-to-check-
# the-status-of-a-shell-script-using-subprocess-module-in-python
# http://zx2c4.com/projects/password-store/
# is used for password management
password = subprocess.Popen (["pass", email], stdout=subprocess.PIPE) \
                     .communicate ()[0][:-1]
imapreq = b"""a login %s %s\r
a status INBOX (UNSEEN)\r
a logout\r
""" % (email, password)

def usr1handler (a1, a2):
    global prevt
    prevt = 0
signal.signal (signal.SIGUSR1, usr1handler)
mailcheckinterval = 20*60 #4*60*60

# SSL code taken almost verbatim from:
# https://wiki.python.org/moin/SSL

unspat = re.compile (r".*\(UNSEEN ([1-9][0-9]*).*")
def checkmail (t):
    global prevt, prevunseen, mailcheckinterval, imapreq
    n = prevunseen
    if t - prevt > mailcheckinterval:
        try:
            sock = socket.socket()
            sock.connect((HOST, PORT))

            # wrap socket to add SSL support
            sock1 = ssl.wrap_socket (sock)
            sock1.read ()
            sock1.write (imapreq)
            sock1.read ()
            s = sock1.read ()
            try:
                m = unspat.match (s.decode ())
            except:
                m = "error: " + s
            n = 0
            if m:
                n = int (m.group (1))
            sock1.close ()
            sock.close ()
        except:
            n = 0

        prevt = t
        prevunseen = n
    return n

def gets (path):
    try:
        with open (path) as f:
            return f.read ()
    except:
        pass

def getl (path):
    try:
        with open (path) as f:
            return f.readline ()
    except:
        pass

def getf (path):
    return float (gets (path))

class N:
    def __init__ (self, intf):
        tx = "/sys/class/net/" + intf + "/statistics/tx_bytes"
        rx = "/sys/class/net/" + intf + "/statistics/rx_bytes"
        self.getv = lambda: (getf (tx), getf (rx))
        self.prevT = time.time ()
        self.prevV = self.getv ()
        self.intf = intf

    def step (self, curT):
        curV = self.getv ()
        dt = curT - self.prevT
        self.prevT = curT
        color = None
        s = "N"
        for i in range (len (curV)):
            c = curV[i]
            p = self.prevV[i]
            dv = (c - p) * 1e-6
            if dv > 0.5:
                color = "#cdba96"
            s += " %5.2f" % (dv/dt)
        self.prevV = curV
        return (color, s) if color is not None else None

class C:
    def __init__ (self, path, xgetv):
        name = gets (os.path.dirname (path) + "/name")[:-1]
        self.name = translate.get (name, name)
        self.getv = lambda: xgetv (path)
        self.prevT = time.time ()
        self.prevV = self.getv ()

    def step (self, curT):
        curV = self.getv ()
        dvdt = ((curV-self.prevV)*1e-6)/(curT-self.prevT)
        self.prevT = curT
        self.prevV = curV
        skip = False
        c = self.name
        if c == 'p':
            cond = dvdt < 5
        elif c == 'm':
            cond = skip = dvdt < 0.3
        elif c == 'g':
            cond = skip = dvdt < 1
        elif c == 'c':
            cond = skip = dvdt < 0.3
        else:
            cond = False
        if skip:
            return None
        else:
            return ("#a9a9a9" if cond else "#d0d000",
                    "%s %5.2f" % (self.name, dvdt))

class I:
    def getv (self):
        l = gets ("/proc/stat").split ()
        return (int (l[5]))

    def __init__ (self):
#        self.h = 0
        self.prevV = self.getv ()
        self.prevT = time.time ()

    def step (self, curT):
        curV = self.getv ()
        dvdt = ((curV-self.prevV)/100)/(curT-self.prevT)
        self.prevT = curT
        self.prevV = curV
        per = int (100*dvdt)
        # http://stackoverflow.com/questions/394809/does-python-have-a-ternary-conditional-operator
        return (("#cdba96" if per > 7 else "#909090"), "%3d%%" % per)

paths = ["energy_uj",
         "intel-rapl:0:0/energy_uj",
         "intel-rapl:0:1/energy_uj",
         "intel-rapl:0:2/energy_uj"]

translate = {"package-0" : "p",
             "core"      : "c",
             "uncore"    : "g",
             "dram"      : "m"}

raplprefix = "/sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/"
rs = [C (raplprefix + path, getf) for path in paths]

cs = rs + [N ("enp3s0f0"), I ()]

d = {'SwapTotal': 0, 'SwapFree': 0}
def swapused ():
    global d
    with open ("/proc/meminfo") as f:
        for line in f.readlines ():
            f = line.split (':')
            v = d.get (f[0])
            if v is not None:
                f2 = f[1][:-1].lstrip ().split(' ')
                if f2[1] == 'kB':
                    v = float (f2[0])
                    d[f[0]] = v

    total = d['SwapTotal']
    if total > 0:
        free = d['SwapFree']
        per = 100 * (1 - (free / total))
        return per if per > 0.01 else 0
    else:
        return 0

def main ():
    sleepsecs = float (sys.argv[1])
    pf = select.poll ()
    msg = None
    ff = None
    deadline = None
    winfo = None

    while True:
        if not ff:
            ff = os.open (sys.argv[2], os.O_RDONLY | os.O_NONBLOCK)
            pf.register (ff, select.POLLIN | select.POLLHUP)

        l = pf.poll (sleepsecs * 1000)
        t = time.time ()

        for (fd, mask) in l:
            if mask & select.POLLIN:
                msg1 = os.read (ff, 4096)
                msg = msg1.decode ()
                parts = msg.split ('\x00')
                try:
                    msg = parts[0]
                    tmout = parts[1]
                    deadline = t + float (tmout)
                except:
                    deadline = None

            if mask & select.POLLHUP:
                pf.unregister (fd)
                os.close (fd)
                ff = None

        if msg and msg[0] == '\x02':
            winfo = msg[1:]
            msg = None

        if msg == '\x01':
            msg = None

        if deadline and t > deadline:
            msg = None
            deadline = None

        j = [{"color": "#00ff00", "full_text": msg}] if msg else []

        nmail = checkmail (t)
        if nmail > 0:
            j += [{"color": "#ffff00", "full_text": "🅼 %d" % nmail}]

        if winfo:
            j += [{"color": "#a9a9a9", "full_text": winfo}]

        for c in cs:
            s = c.step (t)
            if s is not None:
                (color, s) = s
                j += [{"color": color, "full_text": "%s" % s}]

        j += [{"color": "#a9a9a9",
               "full_text": time.strftime ('[%H:%M]', time.localtime (t))}]

        temp = 1e-3 * getf ("/sys/class/thermal/thermal_zone0/temp")
        j += [{"color": "#a9a9a9", "full_text": "%d°" % temp}]

        swap = swapused ()
        if swap != 0:
            j += [{"color": "#a9a9a9", "full_text": "swap %5.1f%%" % swap}]

        print ("%s," % json.dumps (j), flush=True)

print ('{ "version": 1 } [', flush=True)
main ()
