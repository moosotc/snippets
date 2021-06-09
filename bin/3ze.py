# -*- coding: utf-8 -*-
import sys, fontforge, getopt

opts, args = getopt.getopt (sys.argv[1:], "03")
oh0 = False
ze3 = False
for opt in opts:
    if opt[0] == "-0":
        oh0 = True
    if opt[0] == "-3":
        ze3 = True

a = fontforge.open (args[0])
b = a

if ze3:
    #ch = ord ('\N{LATIN CAPITAL LETTER YOGH}')
    #ch = ord ('\N{LATIN SMALL LETTER YOGH}') # descends beyond baselin
    #ch = ord ('\N{LATIN SMALL LETTER EZH}')
    ch = ord ('\N{CYRILLIC CAPITAL LETTER ABKHASIAN DZE}')
    a.selection.select (ch)
    b = a
    a.copy ()
    b.selection.select("3")
    b.paste ()

if oh0:
    # ch = ord ('\N{LATIN CAPITAL LETTER O WITH STROKE}')
    ch = ord ('\N{CYRILLIC CAPITAL LETTER FITA}')
    a.selection.select (ch)
    a.copy ()
    b.selection.select("0")
    b.paste ()

b.generate(args[1], flags=("opentype", "no-hints"))
