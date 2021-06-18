# -*- coding: utf-8 -*-
import sys, fontforge, getopt

opts, args = getopt.getopt (sys.argv[1:], "03Il")
oh0 = False
ze3 = False
upI = False
ell = False
for opt in opts:
    if opt[0] == "-0":
        oh0 = True
    if opt[0] == "-3":
        ze3 = True
    if opt[0] == "-I":
        upI = True
    if opt[0] == "-l":
        ell = True

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
    ch = ord ('\N{LATIN LETTER BILABIAL CLICK}')
    a.selection.select (ch)
    a.copy ()
    b.selection.select("0")
    b.paste ()

if ell:
#    c = '\N{LATIN SMALL LETTER L WITH RETROFLEX HOOK}'
#    c = '\N{LATIN SMALL LETTER L WITH BAR}'
#    c = '\N{LATIN SMALL LETTER L WITH CURL}'
#    c = '\N{GREEK SMALL LETTER LAMDA}'
#    c = '\N{HEBREW LETTER LAMED}'
    c = '\N{latin small letter l with middle tilde}'
    ch = ord (c)
    a.selection.select (ch)
    a.copy ()
    b.selection.select("l")
    b.paste ()

if upI:
    # this does not appear to be working
    # perhaps I is used as a reference of some sort?
    # ch = ord ('\N{LATIN CAPITAL LETTER I WITH OGONEK}')
    ch = ord ('\N{LATIN CAPITAL LETTER I WITH DOT ABOVE}') # "İ"
    a.selection.select (ch)
    a.copy ()
    b.selection.select("I")
    b.paste ()

b.generate(args[1], flags=("opentype", "no-hints"))
