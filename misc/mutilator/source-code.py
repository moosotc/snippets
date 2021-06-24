# -*- coding: utf-8 -*-
# for f in {Light,LightItalic,Bold,BoldItalic}; do python ~/xsrc/snippets/misc/mutilator/source-code.py ~/x/fnt/git/google-fonts/ofl/sourceccodepro/SourceCodePro-$f.ttf $f.ttf; done
import sys, fontforge

a = fontforge.open (sys.argv[1])

a.selection.select (0x292)
b = a
a.copy ()
b.selection.select("3")
b.paste ()

b.generate(sys.argv[2], flags=("opentype", "no-hints"))
