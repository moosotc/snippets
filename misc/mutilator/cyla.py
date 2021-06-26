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
    'k' : 'ъ',
    'l' : 'л',
    'm' : 'м',
    'n' : 'н',
    'p' : 'п',
    'r' : 'р',
    'q' : 'ъ',
    's' : 'ш',
    't' : 'ѿ',
    'u' : 'ю',
    'v' : 'в',
    'w' : 'ӱ',
    'x' : 'ꙛ',
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
    'M' : 'М',
    'N' : 'Н',
    'P' : 'П',
    'Q' : 'Ъ',
    'R' : 'Р',
    'S' : 'Ш',
    'T' : 'Ѿ',
    'U' : 'Ю',
    'V' : 'В',
    'W' : 'Ӱ',
    'X' : 'Ꙛ',
    'Y' : 'Ы',
    'Z' : 'З',
}

b = a
for d,s in d.items():
    a.selection.select (ord (s))
    a.copy ()

    b.selection.select (ord (d))
    b.paste ()

b.generate(sys.argv[2], flags=("opentype", "no-hints"))
