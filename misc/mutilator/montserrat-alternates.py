# -*- coding: utf-8 -*-

"""
for f in ~/x/fnt/git/Montserrat/fonts/otf/*Alt*-{Bold,Light}*; do
  python ~/xsrc/snippets/misc/mutilator/montserrat-alternates.py $f $(basename $f)
done
"""

import sys, fontforge

a = fontforge.open (sys.argv[1])
a.selection.select (ord ('\N{LATIN CAPITAL LETTER O WITH STROKE}')) # Ø
b = a
a.copy ()
b.selection.select ("0")
b.paste ()

b.generate(sys.argv[2], flags=("opentype", "no-hints"))
