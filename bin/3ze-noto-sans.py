# -*- coding: utf-8 -*-
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

a.selection.select (ord ('ɭƖꙆꙇ'[0]))
a.copy ()
b.selection.select('l')
b.paste ()

b.generate(sys.argv[2], flags=("opentype", "no-hints"))
