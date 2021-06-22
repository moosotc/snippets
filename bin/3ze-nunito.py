# -*- coding: utf-8 -*-

# for f in $(find ~/x/fnt/fix/nunito/manually-dotted-zera -name '*ttf'); do python ~/xsrc/snippets/bin/3ze-nunito.py $f $(basename $f); done

import sys, fontforge

a = fontforge.open (sys.argv[1])

# Ӥ - CYRILLIC CAPITAL LETTER I WITH DIAERESIS
# Ѝ - CYRILLIC CAPITAL LETTER I WITH GRAVE
# Ӣ - CYRILLIC CAPITAL LETTER I WITH MACRON
# Í - LATIN CAPITAL LETTER I WITH ACUTE
# Ĭ - LATIN CAPITAL LETTER I WITH BREVE
# Ǐ - LATIN CAPITAL LETTER I WITH CARON
# Î - LATIN CAPITAL LETTER I WITH CIRCUMFLEX
# Ï - LATIN CAPITAL LETTER I WITH DIAERESIS
# Ḯ - LATIN CAPITAL LETTER I WITH DIAERESIS AND ACUTE
# İ - LATIN CAPITAL LETTER I WITH DOT ABOVE
# Ị - LATIN CAPITAL LETTER I WITH DOT BELOW
# Ȉ - LATIN CAPITAL LETTER I WITH DOUBLE GRAVE
# Ì - LATIN CAPITAL LETTER I WITH GRAVE
# Ỉ - LATIN CAPITAL LETTER I WITH HOOK ABOVE
# Ȋ - LATIN CAPITAL LETTER I WITH INVERTED BREVE
# Ī - LATIN CAPITAL LETTER I WITH MACRON
# Į - LATIN CAPITAL LETTER I WITH OGONEK
# Ɨ - LATIN CAPITAL LETTER I WITH STROKE
# Ĩ - LATIN CAPITAL LETTER I WITH TILDE
# Ḭ - LATIN CAPITAL LETTER I WITH TILDE BELOW
# ᵻ - LATIN SMALL CAPITAL LETTER I WITH STROKE

a = fontforge.open (sys.argv[1])

a.selection.select (ord ('\N{LATIN CAPITAL LETTER I WITH DOT BELOW}'))
b = a
a.copy ()
b.selection.select("I")
b.paste ()

a.selection.select (ord ('Ӡ'))
b = a
a.copy ()
b.selection.select("3")
b.paste ()

b.generate(sys.argv[2], flags=("opentype", "no-hints"))
