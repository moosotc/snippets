#!/usr/bin/env python
# -*- coding: utf-8 -*-

# SSL code based taken almost verbatim from:
# https://wiki.python.org/moin/SSL

# 1F4E7 📧 E-MAIL SYMBOL
#  2B06 ⬆
#  2B07 ⬇
import time, os, sys, select, signal, subprocess
import socket, ssl, re, json

HOST = "imap.gmail.com"
PORT = 993
HOST = socket.getaddrinfo (HOST, PORT)[0][4][0]
unspat = re.compile (r".*\(UNSEEN ([1-9][0-9]*).*")

prevunseen = 0
prevt = 0
previt = 0

email = b"moosotc@gmail.com"

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
mailcheckinterval = 20*60

def checkmail (t):
    global prevt, prevunseen, mailcheckinterval, imapreq
    n = prevunseen
    if t - prevt > mailcheckinterval:
        # print ("checking mail")
        try:
            sock = socket.socket()
            sock.connect((HOST, PORT))

            # wrap socket to add SSL support
            sock = ssl.wrap_socket (sock)
            sock.read ()
            sock.write (imapreq)
            sock.read ()
            s = sock.read ()
            try:
                m = unspat.match (s.decode ())
            except:
                m = "error: " + s
            n = 0
            if m:
                n = int (m.group (1))
            sock.close ()
        except:
            n = 0

        prevt = t
        prevunseen = n
    return n

def gets (path):
    try:
        with open (path) as f:
            s = f.read ()
            return s
    except:
        pass

def getf (path):
    return float (gets (path))

translate = {
    "package-0" : "pkg",
    "core"      : "cpu",
    "uncore"    : "gpu",
    "dram"      : "ram"
}

class N:
    def __init__ (self, name, path, xgetv):
        self.tx = name == "tx"
        self.getv = lambda: xgetv (path)
        self.prevT = time.time ()
        self.prevV = self.getv ()

    def step (self, curt):
        curv = self.getv ()
        dt = curt - self.prevT
        self.prevT = curt
        dv = (curv - self.prevV) * 1e-6
        self.prevV = curv
        if dv > 0.5:
            if self.tx:
                color = "#ffff00"
                s = "↑ "
            else:
                color = "#00ff00"
                s = "↓ "
        else:
            color = "#a9a9a9"
            if self.tx:
                s = "tx"
            else:
                s = "rx"
        return (color, s, dv/dt)

class C:
    def __init__ (self, path, xgetv):
        name = gets (os.path.dirname (path) + "/name")[:-1]
        self.name = translate.get (name, name)
        self.getv = lambda: xgetv (path)
        self.prevT = time.time ()
        self.prevV = self.getv ()

    def step (self, curt):
        curv = self.getv ()
        dvdt = ((curv-self.prevV)*1e-6)/(curt-self.prevT)
        self.prevT = curt
        self.prevV = curv
        return ("#a9a9a9", self.name, dvdt)

class I:
    def getv (self):
        f = open ("/proc/stat")
        l = f.readline ().split ()
        f.close ()
        return (int (l[5]))

    def __init__ (self):
        self.prevV = self.getv ()
        self.prevT = time.time ()

    def step (self, curt):
        curv = self.getv ()
        dvdt = ((curv-self.prevV)*1e-3)/(curt-self.prevT)
        self.prevT = curt
        self.prevV = curv
        if dvdt > 0.003:
            return ("#b0b0b0", "⌛", dvdt)
        else:
            return ("#909090", "i", dvdt)

paths = ["energy_uj",
         "intel-rapl:0:0/energy_uj",
         "intel-rapl:0:1/energy_uj",
         "intel-rapl:0:2/energy_uj"]

raplprefix = "/sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/"
rs = [C (raplprefix + path, getf) for path in paths]

netprefix = "/sys/class/net/enp3s0f0/statistics/"
tys = ["rx", "tx"]
ns = [N (ty, netprefix + ty + "_bytes", getf) for ty in tys]

cs = rs + ns + [I ()]

def main ():
    sleepsecs = float (sys.argv[1])
    msg = ""
    pf = select.poll ()
    ff = None

    while True:
        if ff == None:
            ff = os.open (sys.argv[2], os.O_RDONLY | os.O_NONBLOCK)
            pf.register (ff, select.POLLIN | select.POLLHUP)

        l = pf.poll (sleepsecs * 1000)
        for (fd, mask) in l:
            if mask & select.POLLIN:
                msg1 = os.read (ff, 4096)
                msg = msg1.decode ()
            if mask & select.POLLHUP:
                pf.unregister (fd)
                os.close (fd)
                ff = None

        if msg == '\x01':
            msg = ""

        if msg:
            s = '{"color":"#00ff00","full_text":"' + msg + '"},'
        else:
            s = ''

        t = time.time ()
        nmail = checkmail (t)
        if nmail > 0:
            s += '{"color":"#ffff00","full_text":"%d📧"},' % nmail

        for c in cs:
            (c, l, v) = c.step (t)
            s += '{"color":"%s","full_text":"%s %7.3f"},' % (c, l, v)

        t = 1e-3 * getf ("/sys/class/thermal/thermal_zone0/temp")
        s += '{"color":"#a9a9a9","full_text":"%d°"}' % t

        try:
            print ('[%s],' % s, flush=True)
        except:
            print ("Exception", file=sys.stderr)

print ('{ "version": 1 }[', flush=True)
main ()
