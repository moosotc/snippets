# -*- coding: utf-8 -*-
import sys, fontforge

try:
    if sys.argv[1] == '-0':
        o0 = True
        sys.argv = sys.argv[1:]
        sys.argv.remove (1)
    else:
        o0 = False
except:
    sys.exit (1)

a = fontforge.open(sys.argv[1])
#ch = ord ('\N{LATIN CAPITAL LETTER YOGH}')
#ch = ord ('\N{LATIN SMALL LETTER YOGH}') # descends beyond baselin
ch = ord ('\N{LATIN SMALL LETTER EZH}')
#ch = ord ('\N{CYRILLIC CAPITAL LETTER ABKHASIAN DZE}')
a.selection.select (ch)

b = a
a.copy ()
b.selection.select("3")
b.paste ()

# 3ze.sh can't pass arguments down here so...
# o0 = True
if o0:
    a.selection.select (ord ('\N{LATIN CAPITAL LETTER O WITH STROKE}'))
    a.copy ()
    b.selection.select("0")
    b.paste ()

b.generate(sys.argv[2], flags=("opentype", "no-hints"))
