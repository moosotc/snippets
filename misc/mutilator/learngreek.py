# -*- coding: utf-8 -*-
import sys, fontforge
"""
for f in ~/x/fnt/files/noto/serif/*.ttf; do
  python ~/xsrc/snippets/misc/mutilator/learngreek.py $f $(basename $f)
done
"""

# https://en.wikipedia.org/wiki/Greek_alphabet
xtbl = {
    'α' : 'a',
    'ε' : 'e',
    'η' : 'i',
    'ω' : 'o',

    'β' : 'b',
    'γ' : 'g',
    'δ' : 'd',
    'ζ' : 'z',

    'κ' : 'k',
    'λ' : 'l',
    'μ' : 'm',
    'ν' : 'n',
    'ξ' : 'x',
    'π' : 'p',
    'ρ' : 'r',
    'σ' : 's',
    'τ' : 't',
    'φ' : 'f',
    'χ' : 'h',

    'Η' : 'I',
    'Ω' : 'O',
    'Γ' : 'G',
    'Δ' : 'D',
    'Λ' : 'L',
    'Ξ' : 'X',
    'Π' : 'P',
    'Ρ' : 'R',
    'Σ' : 'S',
    'Φ' : 'F',
    'Χ' : 'H',

}

a = fontforge.open (sys.argv[1])
b = a
for s,d in xtbl.items():
    a.selection.select (ord (s))
    a.copy ()

    b.selection.select (ord (d))
    b.paste ()

a.selection.select ('zero.slash')
a.copy ()
b.selection.select ("0")
b.paste ()

a.selection.select (ord ('\N{CYRILLIC CAPITAL LETTER ABKHASIAN DZE}')) # Ӡ
a.copy ()
b.selection.select ("3")
b.paste ()

b.generate(sys.argv[2], flags=("opentype", "no-hints"))
