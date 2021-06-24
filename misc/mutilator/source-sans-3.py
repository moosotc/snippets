# -*- coding: utf-8 -*-
# https://github.com/adobe-fonts/source-sans
"""
for f in {Light,LightIt,Bold,BoldIt}; do
  python ~/xsrc/snippets/misc/mutilator/source-sans-3.py \
    ~/x/fnt/git/source-sans/TTF/SourceSans3-$f.ttf $f.ttf
done
"""
import sys, fontforge

a = fontforge.open (sys.argv[1])

a.selection.select ('I.a')
b = a
a.copy ()
b.selection.select("I")
b.paste ()

a.selection.select ('zero.0s')
b = a
a.copy ()
b.selection.select("0")
b.paste ()

a.selection.select (0x292)
b = a
a.copy ()
b.selection.select("3")
b.paste ()

b.generate(sys.argv[2], flags=("opentype", "no-hints"))
