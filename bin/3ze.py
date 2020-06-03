# -*- coding: utf-8 -*-
import sys,fontforge

try:
    if sys.argv[1] == '-0':
        o0 = True
        sys.argv = sys.argv[1:]
    else:
        o0 = False
except:
    sys.exit (1)

a = fontforge.open(sys.argv[1])
a.selection.select (
#    ord ('\N{LATIN SMALL LETTER EZH}')
    ord ('\N{CYRILLIC CAPITAL LETTER ABKHASIAN DZE}')
#    ord ('\N{LATIN CAPITAL LETTER YOGH}')
#    ord ('\N{LATIN SMALL LETTER YOGH}') # descends beyond baseline
)
b = a
a.copy ()
b.fontname = a.fontname + "-3ze"
b.selection.select("3")
b.paste ()

if o0:
    a.selection.select (ord ('\N{LATIN CAPITAL LETTER O WITH STROKE}'))
    a.copy ()
    b.selection.select("0")
    b.paste ()

b.generate(sys.argv[2])
