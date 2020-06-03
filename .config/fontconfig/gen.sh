#!/bin/sh

# export FONTCONFIG_FILE=$HOME/.config/fontconfig/fonts.conf
# prior to starting X to get reproducible distribution independent behavior

# https://eev.ee/blog/2015/05/20/i-stared-into-the-fontconfig-and-the-fontconfig-stared-back-at-me/

# beograd        https://www.fontspace.com/beograd-font-f28002
# symbola        http://users.teilar.gr/~g1951d/
# iosevka        https://github.com/be5invis/Iosevka
#    clam        https://github.com/moosotc/snippets/blob/master/bin/configure/private-build-plans.toml
# alegreya       https://www.huertatipografica.com/en
# pt(astra)      https://www.paratype.ru/collections/pt/44157
# xo             https://fonts.myoffice.ru
# raleway        https://github.com/impallari/Raleway
#   (original)   https://github.com/theleagueof/raleway
# dudu cyryllic  https://www.fontspace.com/vladmas
# code 2003      https://en.wikipedia.org/wiki/Code2000
#                https://www.fontspace.com/code2003-font-f24444
# montserrat     https://github.com/JulietaUla/Montserrat/
# noto           https://github.com/googlefonts/noto-fonts/tree/master/hinted
#                https://www.google.com/get/noto/

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
I() {
    cat <<EOF
  <match target="pattern">
    <test qual="any" name="family"><string>$1</string></test>
    <test qual="any" name="slant"><const>italic</const></test>
    <edit name="family" mode="assign" binding="strong">
      <string>$2</string>
    </edit>
  </match>
EOF
}
B() {
    cat <<EOF
  <match target="pattern">
    <test qual="any" name="family"><string>$1</string></test>
    <test qual="any" name="weight" compare="more_eq"><const>bold</const></test>
    <edit name="family" mode="assign" binding="strong">
      <string>$2</string>
    </edit>
  </match>
EOF
}

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
      <string>symbola</string>
    </edit>
  </match>
EOF

S "monospace"       "iosevka"
S "mono"            "iosevka"
S "consolas"        "iosevka"
S "iosevka"         "iosevka clam"

S "serif"           "alegreya"

for f in "times" "times new roman";
do
    S "$f" "pt astra serif"
done

for f in "sans" "sans-serif" "arial" "helvetica" "cnn" "roboto";
do
    S "$f" "xo oriel"
done

S "calibri"         "xo caliburn"
S "trebuchet ms"    "xo trebizond"
S "tahoma"          "xo tahion"

I "xo tahion"       "pt astra sans"
I "xo trebizond"    "beograd"
B "xo trebizond"    "beograd"

S "segoe ui"        "raleway-v4020" # github, channel9

S "ui"              "pt sans"
# learn yourself some greek
S "linux libertine" "xo symbol"

# large x-height sans
for f in "bitstream vera sans"                  \
         "verdana"                              \
         "open sans"                            \
         "opensans"                             \
         "droid sans"                           \
         "lucida"                               \
         "lucida grande"                        \
         "dejavu sans"
do
    S "$f" "montserrat alternates" "noto sans"
done

# large x-height serif
for f in "droid serif" "noto serif" "dejavu serif" "georgia";
do
    S "$f" "pt serif"
done

# used....
S "cantarell"     "beograd"
S "comic sans ms" "Dudu Cyryllic"

echo "</fontconfig>"

# Local Variables:
# compile-command: "./gen.sh"
# whitespace-line-column: 100
# truncate-lines: t
# End:
