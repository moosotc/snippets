# -*- coding: utf-8 -*-
import sys, fontforge
"""
for f in ~/x/fnt/files/noto/serif/*.ttf; do
  python ~/xsrc/snippets/misc/mutilator/cyla.py $f $(basename $f)
done
"""

a = fontforge.open (sys.argv[1])

d = {
    'a' : 'љ',
    'b' : 'б',
    'c' : 'ц',
    'd' : 'д',
    'e' : 'є',
    'f' : 'ф',
    'g' : 'г',
    'h' : 'ш',
    'i' : 'и',
    'j' : 'ж',
    'k' : 'ъ',
    'l' : 'л',
    'm' : 'м',
    'n' : 'н',
    'o' : 'у',
    'p' : 'п',
    'q' : 'ъ',
    'r' : 'р',
    's' : 'с',
    't' : 'ѿ',
    'u' : 'ю',
    'v' : 'в',
    'w' : 'ѡ',
    'x' : 'ꙛ',
    'y' : 'ы',
    'z' : 'з',

    'A' : 'Љ',
    'B' : 'Б',
    'C' : 'Ц',
    'D' : 'Д',
    'E' : 'Є',
    'F' : 'Ф',
    'G' : 'Г',
    'H' : 'ш',
    'I' : 'И',
    'J' : 'Ж',
    'K' : 'Ъ',
    'L' : 'Л',
    'M' : 'Ѫ',
    'N' : 'Н',
    'O' : 'У',
    'P' : 'П',
    'Q' : 'Ъ',
    'R' : 'Р',
    'S' : 'С',
    'T' : 'Ѿ',
    'U' : 'Ю',
    'V' : 'В',
    'W' : 'Ѡ',
    'X' : 'Ꙛ',
    'Y' : 'Ы',
    'Z' : 'З'
}

b = a
for d,s in d.items():
    a.selection.select (ord (s))
    a.copy ()

    b.selection.select (ord (d))
    b.paste ()

b.generate(sys.argv[2], flags=("opentype", "no-hints"))
