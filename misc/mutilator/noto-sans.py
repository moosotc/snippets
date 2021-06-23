# -*- coding: utf-8 -*-

# for f in $(find ~/x/fnt/fix/noto -name '*ttf'); do python ~/xsrc/snippets/misc/mutilator/noto-sans.py $f $(basename $f); done

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

b.generate(sys.argv[2], flags=("opentype", "no-hints"))
