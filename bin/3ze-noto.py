# -*- coding: utf-8 -*-
# for f in orig/*.ttf; do python /home/malc/xsrc/snippets/bin/3ze-noto-sans.py $f $(basename $f); done
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

a.selection.select (ord ('ɭƖꙆꙇƖ'[4]))
a.copy ()
b.selection.select('l')
b.paste ()

b.generate(sys.argv[2], flags=("opentype", "no-hints"))
