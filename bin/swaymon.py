#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys, select, time, json

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

def main ():
    sleepsecs = float (sys.argv[1])
    pf = select.poll ()
    msg = None
    ff = None
    deadline = None

    while True:
        l = pf.poll (sleepsecs * 1000)
        t = time.time ()

        j = [{"color": "#00ff00", "full_text": msg}] if msg else []
        j += [{"color": "#a9a9a9",
               "full_text": time.strftime ('[%H:%M]', time.localtime (t))}]

        print ("%s," % json.dumps (j), flush=True)

print ('{ "version": 1 }\n[', flush=True)
main ()
