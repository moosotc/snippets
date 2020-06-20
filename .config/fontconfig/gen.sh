#!/bin/sh

# export FONTCONFIG_FILE=$HOME/.config/fontconfig/fonts.conf
# prior to starting X to get reproducible distribution independent behavior

# consistent diacritics (trema/umalut/(double) accute) are a lost cause it seems

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
# fantasque sans https://github.com/belluzj/fantasque-sans
# ruslan display https://fonts.google.com/specimen/Ruslan+Display
# nobile         https://github.com/vernnobile/NobileFont/
#                https://github.com/vernnobile/NobileFont/issues/3#issuecomment-643729656
# lora cyrillic  https://github.com/cyrealtype/Lora-Cyrillic
# symbol         https://source.winehq.org/git/wine.git/blob/HEAD:/fonts/symbol.ttf

test -z $1 && exec >${FONTCONFIG_FILE-$HOME/.config/fontconfig/fonts.conf}
S() {
  echo '  <match target="pattern">'
  echo '    <test qual="any" name="family"><string>'$1'</string></test>'
  shift
  printf '    <edit name="family" mode="assign_replace">'
  printf '<string>%s</string></edit>\n' "$1"
  shift
  for f in "$@"; do
      printf '    <edit name="family" mode="append">'
      printf '<string>%s</string></edit>\n' "$f"
  done
  echo '  </match>'
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
    <edit name="family" mode="assign"><string>noto sans</string></edit>
  </match>
  <match target="pattern">
    <test name="family"><string>mpvsub</string></test>
    <test name="weight" compare="more_eq"><const>bold</const></test>
    <edit name="family" mode="assign"><string>noto sans</string></edit>
  </match>
  <match target="pattern">
    <test name="family"><string>mpvsub</string></test>
    <edit name="family" mode="assign_replace"><string>dudu cyrillic</string></edit>
  </match>
EOF

Smany "fantasque sans mono" "ubuntu" "consolas" "uimono"
Smany "dudu cyryllic"  "comic sans ms"
Smany "iosevka clam"   "iosevka" "mono" "monospace" "sfmono-regular"
Smany "pt astra serif" "times" "times new roman"
Smany "noto sans"      "helvetica" "arial" "cnn" "roboto" "sans" "sans-serif"
Smany "pt serif"       "domine"
Smany "lora"           "georgia"
Smany "alegreya"       "serif"

S "mpvosd"          "noto sans bold"
S "calibri"         "pt astra sans"
S "segoe ui"        "raleway-v4020" # github, channel9
S "ui"              "pt sans"

Smany "montserrat alternates" "lucida" "lucida grande" "trebechet ms"
Smany "nobile" "dejavu sans" "helvetica neue" "bitstream vera sans"
Smany "ruslan display" "droid serif" "noto serif" "dejavu serif"
Smany "noto sans" "verdana" "open sans" "opensans" "droid sans"
Smany "beograd" "constantia" "cambria" "corbel" "tahoma"

# learn yourself some greek
Smany "symbol" "segoe" "courier new" "linux libertine"

echo "</fontconfig>"

# Local Variables:
# compile-command: "./gen.sh"
# whitespace-line-column: 100
# truncate-lines: t
# End:
