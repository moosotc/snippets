# -*- coding: utf-8 -*-
import sys, fontforge
"""
for f in ~/x/fnt/files/noto/serif/*.ttf; do
  python ~/xsrc/snippets/misc/mutilator/cyla.py $f $(basename $f)
done
"""

a = fontforge.open (sys.argv[1])

d = {
    'b' : 'б',
    'c' : 'ц',
    'd' : 'д',
    'e' : 'є',
    'f' : 'ф',
    'g' : 'г',
    'h' : 'х',
    'i' : 'и',
    'j' : 'ж',
    'k' : 'ϰ',
    'l' : 'л',
    'm' : 'м',
    'n' : 'н',
    'p' : 'π',
    'r' : 'я',
    'q' : 'ъ',
    's' : 'ш',
    't' : 'τ',
    'u' : 'ю',
    'v' : 'в',
    'w' : 'ӱ',
    'x' : 'щ',
    'y' : 'ы',
    'z' : 'з',

    'B' : 'Б',
    'C' : 'Ц',
    'D' : 'Д',
    'E' : 'Є',
    'F' : 'Ф',
    'G' : 'Г',
    'H' : 'Х',
    'I' : 'И',
    'J' : 'Ж',
    'K' : 'Ъ',
    'L' : 'Л',
    'M' : 'Ϻ',
    'N' : 'Н',
    'P' : 'Π',
    'Q' : 'Ъ',
    'R' : 'Я',
    'S' : 'Ш',
    'T' : 'Ꚍ',
    'U' : 'Ю',
    'V' : 'В',
    'W' : 'Ӱ',
    'X' : 'Щ',
    'Y' : 'Ы',
    'Z' : 'З',
}

b = a
for d,s in d.items():
    a.selection.select (ord (s))
    a.copy ()

    b.selection.select (ord (d))
    b.paste ()

a.selection.select ('zero.slash')
a.copy ()
b.selection.select ("0")
b.paste ()

a.selection.select (ord ('\N{CYRILLIC CAPITAL LETTER ABKHASIAN DZE}')) # Ӡ
b = a
a.copy ()

b.selection.select ("3")
b.paste ()

b.generate(sys.argv[2], flags=("opentype", "no-hints"))
