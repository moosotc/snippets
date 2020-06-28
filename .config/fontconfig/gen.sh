#!/bin/sh

set -e

# export FONTCONFIG_FILE=$HOME/.config/fontconfig/fonts.conf
# prior to starting X to get reproducible distribution independent behavior

# https://eev.ee/blog/2015/05/20/i-stared-into-the-fontconfig-and-the-fontconfig-stared-back-at-me/

# alegreya       https://www.huertatipografica.com/en/fonts/alegreya-ht-pro
# beograd        https://www.fontspace.com/beograd-font-f28002
# iosevka        https://github.com/be5invis/Iosevka
#    clam        https://github.com/moosotc/snippets/blob/master/bin/configure/private-build-plans.toml
# pt(astra)      https://www.paratype.ru/collections/pt/44157
# raleway        https://github.com/impallari/Raleway
#   (original)   https://github.com/theleagueof/raleway
# dudu cyryllic  https://www.fontspace.com/vladmas
# code2003       https://en.wikipedia.org/wiki/Code2000
#                https://www.fontspace.com/code2003-font-f24444
# montserrat     https://github.com/JulietaUla/Montserrat/
# noto           https://github.com/googlefonts/noto-fonts
#                https://www.google.com/get/noto/
# fantasque sans
#      mono      https://github.com/belluzj/fantasque-sans
# ruslan display https://fonts.google.com/specimen/Ruslan+Display
# lora cyrillic  https://github.com/cyrealtype/Lora-Cyrillic
# symbol         https://source.winehq.org/git/wine.git/blob/HEAD:/fonts/symbol.ttf
# linguistics    https://www.fontsquirrel.com/fonts/linguistics-pro
#     pro        https://en.wikipedia.org/wiki/Utopia_(typeface)#Derived_typefaces
# Mongolian
#  Writing       http://mongolfont.com/jAlmas/cms/documents/mongolfont/font/mnglwritingotf.ttf

test -z $1 && exec >${FONTCONFIG_FILE-$HOME/.config/fontconfig/fonts.conf}
S() { cat<<EOF
<match target="pattern">
  <test name="family"><string>$1</string></test>
  <edit name="family" mode="assign" binding="strong"><string>$2</string></edit>
</match>
EOF
}
Smany () { s="$1"; shift; for f; do S "$f" "$s"; done; }

cat <<EOF
<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<fontconfig>
  <dir>~/.fonts</dir>
  <match target="pattern">
    <edit name="rgba"><const>none</const></edit>
    <edit name="hinting"><bool>false</bool></edit>
    <edit name="hintstyle"><const>hintnone</const></edit>
    <edit name="autohint"><bool>false</bool></edit>
    <edit name="family" mode="append" binding="weak">
      <string>beograd</string>
      <string>code2003</string>
    </edit>
  </match>
  <match target="pattern">
    <test name="family" compare="contains"><string>narrow</string></test>
    <edit name="family" mode="assign"><string>ruslan display</string></edit>
  </match>
  <match target="pattern">
    <test name="family" compare="contains"><string>condensed</string></test>
    <edit name="family" mode="assign"><string>dudu cyryllic</string></edit>
  </match>
  <match target="pattern">
    <test name="family"><string>mpvsub</string></test>
    <test name="slant"><const>italic</const></test>
    <edit name="family" mode="assign_replace" binding="strong"><string>noto sans</string></edit>
  </match>
  <match target="pattern">
    <test name="family"><string>mpvsub</string></test>
    <test name="weight" compare="more_eq"><const>bold</const></test>
    <edit name="family" mode="assign_replace" binding="strong"><string>noto sans</string></edit>
  </match>
  <match target="pattern">
    <test name="family"><string>mpvsub</string></test>
    <edit name="family" mode="assign_replace"><string>dudu cyrillic</string></edit>
  </match>
EOF

S "sans"            "sans-serif"
S "mono"            "monospace"
S "cursive"         "Mongolian Writing"
S "fantasy"         "beograd"

Smany "fantasque sans mono" "uimono" "ubuntu mono" "ubuntu" "consolas" "courier" "courier new"
Smany "dudu cyryllic"  "comic sans ms"
Smany "iosevka clam"   "iosevka" "monospace"
Smany "pt astra serif" "times" "times new roman"

! false || (
    Smany "helvetica lt com" "arial" "helvetica"
    Smany "pragmatica" "arial" "helvetica"
)

Smany "noto sans"      "helvetica" "arial" "cnn" "roboto" "sans-serif"
Smany "raleway-v4020"  "segoe ui"
Smany "pt serif"       "domine"
Smany "lora"           "georgia"
Smany "alegreya"       "serif"
Smany "pt sans"        "ui"
Smany "noto sans bold" "mpvosd"
Smany "pt astra sans"  "calibri"

Smany "montserrat alternates" "lucida" "lucida grande" "opensans"
Smany "noto sans" "dejavu sans" "helvetica neue" "bitstream vera sans"
Smany "linguistics pro" "droid serif" "noto serif" "dejavu serif" "utopia"
Smany "beograd" "constantia" "cambria" "corbel" "tahoma" "trebuchet ms"

# learn yourself some greek
Smany "symbol" "segoe" "linux libertine"

echo "</fontconfig>"

# Local Variables:
# compile-command: "./gen.sh"
# whitespace-line-column: 100
# truncate-lines: t
# End:
