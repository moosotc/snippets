#!/bin/sh
set -e

# export FONTCONFIG_FILE=$HOME/.config/fontconfig/fonts.conf
# prior to starting X to get reproducible distribution-independent behavior

# https://eev.ee/blog/2015/05/20/i-stared-into-the-fontconfig-and-the-fontconfig-stared-back-at-me/

# alegreya        https://www.huertatipografica.com/en/fonts/alegreya-ht-pro
# beograd         https://www.fontspace.com/beograd-font-f28002
# iosevka         https://github.com/be5invis/Iosevka
#    clam         https://github.com/moosotc/snippets/blob/master/bin/configure/private-build-plans.toml
# pt(astra)       https://www.paratype.ru/collections/pt/44157
# raleway         https://github.com/impallari/Raleway
#   (original)    https://github.com/theleagueof/raleway
# dudu cyryllic   https://www.fontspace.com/vladmas
# code2003        https://en.wikipedia.org/wiki/Code2000
#                 https://www.fontspace.com/code2003-font-f24444
# montserrat      https://github.com/JulietaUla/Montserrat/
# fantasque sans
#      mono       https://github.com/belluzj/fantasque-sans
# ruslan display  https://fonts.google.com/specimen/Ruslan+Display
# lora cyrillic   https://github.com/cyrealtype/Lora-Cyrillic
# symbol          https://source.winehq.org/git/wine.git/blob/HEAD:/fonts/symbol.ttf
# linguistics     https://www.fontsquirrel.com/fonts/linguistics-pro
#     pro         https://en.wikipedia.org/wiki/Utopia_(typeface)#Derived_typefaces
# mongolian
#  writing        http://mongolfont.com/jAlmas/cms/documents/mongolfont/font/mnglwritingotf.ttf
# tibetan machine http://www.pktc.org/pktc/download.htm#FreeTypeface
#   unicode       http://www.pktc.org/pktc/download/sft/tibmachinetypeface.zip
# kurinto         https://kurinto.com/
test -z $1 && exec >${FONTCONFIG_FILE-$HOME/.config/fontconfig/fonts.conf}
S() { cat<<EOF
  <match target="pattern">
    <test name="family"><string>$2</string></test>
    <edit name="family" mode="assign" binding="strong">
      <string>$1</string>
    </edit>
  </match>
EOF
}
M () { s="$1"; shift; for f; do S "$s" "$f"; done; }

cat <<EOF
<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<fontconfig>
  <dir>~/.fonts</dir>
  <match target="pattern">
    <edit name="rgba"><const>none</const></edit>
    <edit name="hinting"><bool>false</bool></edit>
    <edit name="family" mode="append" binding="strong">
      <string>beograd</string>
      <string>code2003</string>
    </edit>
  </match>
  <match target="pattern">
    <test name="family"><string>arial narrow</string></test>
    <edit name="family" mode="assign_replace" binding="strong">
      <string>pt sans narrow</string>
    </edit>
  </match>
  <match target="pattern">
    <test name="family" compare="not_eq">
      <string>pt sans narrow</string>
    </test>
    <test name="family" compare="contains">
      <string>narrow</string>
    </test>
    <edit name="family" mode="assign">
      <string>ruslan display</string>
    </edit>
  </match>
  <match target="pattern">
    <test name="family" compare="contains"><string>condensed</string></test>
    <edit name="family" mode="assign"><string>pt sans narrow</string></edit>
  </match>
  <match target="pattern">
    <test name="family"><string>sub</string></test>
    <test name="slant"><const>italic</const></test>
    <edit name="family" mode="assign_replace" binding="strong">
      <string>pt sans</string>
    </edit>
  </match>
  <match target="pattern">
    <test name="family"><string>sub</string></test>
    <test name="weight" compare="more_eq"><const>bold</const></test>
    <edit name="family" mode="assign_replace" binding="strong">
      <string>pt sans</string>
    </edit>
  </match>
EOF

mono2="fantasque sans mono"
ans5="montserrat alternates"
erif5="linguistics pro"
curs="mongolian writing"
kur1="kurinto olde core"
kurn="kurinto olde core narrow"
kurw="kurinto olde core wide"
rale="raleway-v4020"

M "$mono2"         "ubuntu mono" "consolas" "courier" "courier new" "uimono"
M "$rale"          "segoe ui" "arial" "roboto" "sans-serif" "helvetica neue"
M "alegreya"       "serif"
M "pt sans bold"   "osd"
M "pt sans"        "ui" "trebuchet ms"
M "pt sans narrow" "bentonsanscond"
M "lora"           "reithserif" "times, serif" "noto serif"
M "dudu cyryllic"  "comic sans ms" "sub"
M "iosevka clam"   "iosevka" "monospace"
M "pt astra serif" "times" "times new roman"
M "ruslan display" "sans serif"
M "beograd"        "constantia" "corbel" "candara" "calibri" "cambria"
M "symbol"         "linux libertine" # learn yourself some greek
M "$ans5"          "opensans" "noto sans" "verdana" "helvetica" "lucida grande" "open sans"
M "$erif5"         "utopia" "domine" "pt serif" "georgia"
M "$kurw"          "tahoma" "sans" "ubutu"
M "$kurn"          "cantarell"
M "$kur1"          "nyt-franklin"
M "$curs"          "cursive"

echo "</fontconfig>"

# Local Variables:
# compile-command: "./gen.sh"
# whitespace-line-column: 100
# truncate-lines: t
# End:
