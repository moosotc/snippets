# -*- coding: utf-8 -*-
# for f in {Light,LightItalic,Bold,BoldItalic}; do python ~/xsrc/snippets/bin/3ze-source-sans.py ~/x/fnt/git/google-fonts/ofl/sourcesanspro/SourceSansPro-$f.ttf /tmp/$f.ttf; done
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
