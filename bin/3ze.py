# -*- coding: utf-8 -*-
import sys,fontforge

if len (sys.argv) < 3:
    sys.exit (1)

a = fontforge.open(sys.argv[1])               #Open a font
a.selection.select (0x1b7)
a.selection.select (
    ord ('\N{LATIN CAPITAL LETTER EZH}')
#    ord ('\N{LATIN CAPITAL LETTER YOGH}')
#    ord ('\N{LATIN SMALL LETTER YOGH}') # descends beyond baseline
)
b = a
a.copy ()
b.fontname = a.fontname + " 3ze"
b.selection.select("3")
b.paste ()

b.generate(sys.argv[2])

# Local Variables:
# compile-command: "python 3ze.py ~/x/fnt/NotoSans-Regular.ttf 3ze.ttf"
# End:
