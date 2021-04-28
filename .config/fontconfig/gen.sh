#!/bin/sh
# works with fontconfig version 2.13.93
set -eu

# export FONTCONFIG_FILE=$HOME/.config/fontconfig/fonts.conf
# prior to starting X to get reproducible distribution-independent behavior

# https://eev.ee/blog/2015/05/20/i-stared-into-the-fontconfig-and-the-fontconfig-stared-back-at-me/

# beograd         https://www.fontspace.com/beograd-font-f28002
# pt              https://www.paratype.ru/collections/pt/44157
# raleway         https://github.com/impallari/Raleway
#   (original)    https://github.com/theleagueof/raleway
# dudu cyryllic   https://www.fontspace.com/vladmas
# code2003        https://en.wikipedia.org/wiki/Code2000
#                 https://www.fontspace.com/code2003-font-f24444
# montserrat      https://github.com/JulietaUla/Montserrat/
# fantasque sans
#      mono       https://github.com/belluzj/fantasque-sans
# symbol          https://source.winehq.org/git/wine.git/blob/HEAD:/fonts/symbol.ttf
# mongolian
#  writing        http://mongolfont.com/jAlmas/cms/documents/mongolfont/font/mnglwritingotf.ttf
# kurinto         https://kurinto.com/

mon0="fantasque sans mono"
ans5="montserrat alternates"
eri1="kurinto news core"
eri5="pt serif"
curs="mongolian writing"
kurn="kurinto olde core narrow"
rale="raleway-v4020"
helv="$rale"
ptsn="pt sans narrow"

droidsans="opensans 'open sans' 'noto sans' 'droid sans'"

test -z ${1-} && exec >${FONTCONFIG_FILE-$HOME/.config/fontconfig/fonts.conf}
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
  <cachedir>~/.cache/fontconfig</cachedir>
  <match target="pattern">
    <edit name="rgba"><const>none</const></edit>
    <edit name="hinting"><bool>false</bool></edit>
    <edit name="family" mode="append" binding="strong">
      <string>beograd</string>
      <string>code2003</string>
    </edit>
  </match>
  <match target="pattern">
    <test name="family" compare="contains"><string>narrow</string></test>
    <edit name="family" mode="assign_replace"><string>$ptsn</string></edit>
  </match>
  <match target="pattern">
    <test name="family" compare="contains"><string>condensed</string></test>
    <edit name="family" mode="assign"><string>$kurn</string></edit>
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

M "$mon0"         "ubuntu mono" "consolas" "courier" "courier new" "uimono"
M "$rale"         "segoe ui" "roboto" "tahoma" "raleway"
M "$helv"         "sans-serif" "arial" "helvetica" "helvetica neue"
M "pt sans bold"  "osd"
M "pt sans"       "gtk" "trebuchet ms"
M "dudu cyryllic" "comic sans ms" "sub"
M "jetbrainsmono" "iosevka clam" "iosevka" "monospace"
M "iosevka clam"  "iosevka" "monospace"
M "$eri1"         "serif" "times" "times new roman"
M "$eri5"         "georgia" "lora" "noto serif"
eval M "'$ans5'"  "verdana" "'lucida  grande'" "montserrat" $droidsans
M "$curs"         "cursive"

# learn yourself some grek (beograd to learn cyrl instead)
M "symbol"         "linux libertine"

echo "</fontconfig>"

# Local Variables:
# compile-command: "./gen.sh"
# whitespace-line-column: 100
# truncate-lines: t
# End:
