#!/bin/sh

# export FONTCONFIG_FILE=$HOME/.config/fontconfig/fonts.conf
# prior to starting X to get reproducible distribution independent behavior

# https://eev.ee/blog/2015/05/20/i-stared-into-the-fontconfig-and-the-fontconfig-stared-back-at-me/

# beograd        https://www.fontspace.com/beograd-font-f28002
# symbola        https://dn-works.com/ufas/
# iosevka        https://github.com/be5invis/Iosevka
#    clam        https://github.com/moosotc/snippets/blob/master/bin/configure/private-build-plans.toml
# alegreya       https://www.huertatipografica.com/en
# pt(astra)      https://www.paratype.ru/collections/pt/44157
# xo             https://fonts.myoffice.ru
# raleway        https://github.com/impallari/Raleway
#   (original)   https://github.com/theleagueof/raleway
# dudu cyryllic  https://www.fontspace.com/vladmas
# code2003       https://en.wikipedia.org/wiki/Code2000
#                https://www.fontspace.com/code2003-font-f24444
# montserrat     https://github.com/JulietaUla/Montserrat/
# noto           https://github.com/googlefonts/noto-fonts
#                https://www.google.com/get/noto/
# ubuntu         https://design.ubuntu.com/font/
# fantasque sans https://github.com/belluzj/fantasque-sans

test -z $1 && exec >${FONTCONFIG_FILE-$HOME/.config/fontconfig/fonts.conf}
S() {
  echo '  <match target="pattern">'
  echo '    <test qual="any" name="family"><string>'$1'</string></test>'
  shift
  for f in "$@"; do
      printf '    <edit name="family" mode="assign" binding="strong">'
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
  <match>
    <edit name="rgba"><const>none</const></edit>
    <edit name="hinting"><bool>false</bool></edit>
    <edit name="hintstyle"><const>hintnone</const></edit>
    <edit name="autohint"><bool>false</bool></edit>
  </match>
  <match>
    <edit name="family" mode="append" binding="strong">
      <string>beograd</string>
      <string>code2003</string>
      <string>symbola</string>
    </edit>
  </match>
EOF

S "comic sans ms"   "Dudu Cyryllic"
S "serif"           "alegreya"

Smany "iosevka clam"   "iosevka" "mono" "monospace"
Smany "pt astra serif" "times" "times new roman"
Smany "xo oriel"       "sans" "sans-serif" "arial" "helvetica" "cnn" "roboto"

S "calibri"         "pt astra sans"
S "segoe ui"        "raleway-v4020" # github, channel9
S "ui"              "pt sans"
S "uimono"          "fantasque sans mono"

# learn yourself some greek
S "linux libertine" "xo symbol"

Smany "montserrat alternates"                   \
      "lucida"                                  \
      "lucida grande"                           \
      "dejavu sans"                             \
      "helvetica neue"                          \
      "bitstream vera sans"

Smany "noto sans"                               \
      "verdana"                                 \
      "open sans"                               \
      "opensans"                                \
      "droid sans"

Smany "ruslan display" "droid serif" "noto serif" "dejavu serif" "georgia"
Smany "beograd" "constantia" "cambria" "corbel" "tahoma"

cat<<EOF
  <match target="pattern">
    <test name="family" compare="contains"><string>narrow</string></test>
    <edit name="family"><string>ruslan display</string></edit>
  </match>
  <match target="pattern">
    <test qual="any" name="family" compare="contains">
      <string>condensed</string>
    </test>
    <edit name="family"><string>dudu cyryllic</string></edit>
  </match>
</fontconfig>
EOF

# Local Variables:
# compile-command: "./gen.sh"
# whitespace-line-column: 100
# truncate-lines: t
# End:
