# -*- coding: utf-8 -*-
# https://www.latofonts.com/
# https://en.wikipedia.org/wiki/Lato_(typeface)
"""
for f in ~/x/fnt/fix/ln/lato/*ttf; do
  python ~/xsrc/snippets/misc/mutilator/lato.py $f $(basename $f)
done
"""
import sys, fontforge

a = fontforge.open (sys.argv[1])
a.selection.select (ord ('\N{CYRILLIC CAPITAL LETTER ABKHASIAN DZE}'))
b = a
a.copy ()
b.selection.select("3")
b.paste ()

a.selection.select (ord ('\N{LATIN LETTER BILABIAL CLICK}'))
a.copy ()
b.selection.select("0")
b.paste ()

a.selection.select (ord ('\N{LATIN CAPITAL LETTER IOTA}'))
a.copy ()
b.selection.select("l")
b.paste ()

b.generate(sys.argv[2], flags=("opentype", "no-hints"))
