# -*- coding: utf-8 -*-
# https://github.com/bBoxType/FiraSans
"""
for f in $HOME/x/fnt/firago/*.ttf; do
  python ~/xsrc/snippets/misc/mutilator/fira-go.py $f $(basename $f)
done
"""
import sys, fontforge

a = fontforge.open (sys.argv[1])

a.selection.select ('zero.zero')
b = a
a.copy ()
b.selection.select("0")
b.paste ()

a.selection.select (ord ('\N{CYRILLIC CAPITAL LETTER ABKHASIAN DZE}'))
b = a
a.copy ()
b.selection.select("3")
b.paste ()

a.selection.select ("uniA7AE.sc")
b = a
a.copy ()
b.selection.select("I")
b.paste ()

b.generate(sys.argv[2], flags=("opentype", "no-hints"))
