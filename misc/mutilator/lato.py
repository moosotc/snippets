# -*- coding: utf-8 -*-
# for f in $(eval echo ~/x/fnt/git/google-fonts/ofl/lato/\{${a// /,}\}); do python ~/xsrc/snippets/misc/mutilator/lato.py $f $(basename $f); done

import sys, fontforge

a = fontforge.open (sys.argv[1])
a.selection.select (ord ('\N{CYRILLIC CAPITAL LETTER ABKHASIAN DZE}'))
b = a
a.copy ()
b.selection.select("3")
b.paste ()

a.selection.select (ord ('\N{LATIN LETTER BILABIAL CLICK}'))
a.copy ()
b.selection.select("0")
b.paste ()

a.selection.select (ord ('\N{LATIN CAPITAL LETTER IOTA}'))
a.copy ()
b.selection.select("l")
b.paste ()

b.generate(sys.argv[2], flags=("opentype", "no-hints"))
