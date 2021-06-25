# -*- coding: utf-8 -*-

"""
for f in ~/x/fnt/files/noto/*.ttf; do
  python ~/xsrc/snippets/misc/mutilator/noto-sans.py $f $(basename $f)
done
"""

import sys, fontforge

a = fontforge.open (sys.argv[1])
a.selection.select (ord ('\N{CYRILLIC CAPITAL LETTER ABKHASIAN DZE}')) # Ӡ
b = a
a.copy ()
b.selection.select("3")
b.paste ()

a.selection.select ('zero.slash')
a.copy ()
b.selection.select("0")
b.paste ()

if False:
    a.selection.select (ord ('ɭƖꙆꙇ'[0]))
    a.copy ()
    b.selection.select('l')
    b.paste ()

# LATIN SMALL LETTER L WITH RETROFLEX HOOK
# uni1DA9 MODIFIER LETTER SMALL L WITH RETROFLEX HOOK
# uni1DA5 MODIFIER LETTER SMALL IOTA
a.selection.select ('iotaLatin')
# a.selection.select (ord ('\N{LATIN SMALL LETTER L WITH RETROFLEX HOOK}'))
# --- a.selection.select ('uni1DA9')
# --- a.selection.select ('uni1DA5')

a.copy ()
b.selection.select('l')
b.paste ()

b.generate(sys.argv[2], flags=("opentype", "no-hints"))
