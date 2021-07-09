# -*- coding: utf-8 -*-

"""
for f in ~/x/fnt/files/ubuntu/*Mono*ttf; do
  python ~/xsrc/snippets/misc/mutilator/ubuntu-mono.py $f $(basename $f)
done
"""

import sys, fontforge

a = fontforge.open (sys.argv[1])
a.selection.select (ord ('\N{CYRILLIC CAPITAL LETTER ABKHASIAN DZE}')) # Ӡ
b = a
a.copy ()
b.selection.select ("3")
b.paste ()

b.generate(sys.argv[2], flags=("opentype", "no-hints"))
