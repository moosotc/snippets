# -*- coding: utf-8 -*-
import sys,fontforge

if len (sys.argv) < 3:
    sys.exit (1)

a = fontforge.open(sys.argv[1])
a.selection.select (
    ord ('\N{LATIN SMALL LETTER EZH}')
#    ord ('\N{LATIN CAPITAL LETTER YOGH}')
#    ord ('\N{LATIN SMALL LETTER YOGH}') # descends beyond baseline
)
b = a
a.copy ()
b.fontname = a.fontname + "-3ze"
b.selection.select("3")
b.paste ()

a.selection.select (ord ('\N{LATIN CAPITAL LETTER O WITH STROKE}'))
a.copy ()
b.selection.select("0")
b.paste ()

b.generate(sys.argv[2])

# Local Variables:
# compile-command: "sh 3ze.sh ~/x/fnt/git-fonts/google-fonts/ofl/balsamiqsans/*ttf"
# End:
# "~/x/fnt/git-fonts/google-fonts/ofl/bellota/*ttf""
