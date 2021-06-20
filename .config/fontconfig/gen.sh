#!/bin/sh
# works with fontconfig version 2.13.93
set -eu

# export FONTCONFIG_FILE=$HOME/.config/fontconfig/fonts.conf
# prior to starting X to get reproducible distribution-independent behavior

# https://eev.ee/blog/2015/05/20/i-stared-into-the-fontconfig-and-the-fontconfig-stared-back-at-me/

# code2003              https://en.wikipedia.org/wiki/Code2000
#                       https://www.fontspace.com/code2003-font-f24444
# montserrat alternates https://github.com/JulietaUla/Montserrat
# nunito                https://github.com/googlefonts/Nunito
# fantasque sans mono   https://github.com/belluzj/fantasque-sans

fantasque="fantasque sans mono"
jetmono="jetbrains mono"
sans="nunito"
sans="lato"
bigsans="montserrat alternates"

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
      <string>code2003</string>
    </edit>
  </match>
EOF

M "$sans"      "sans-serif" "serif" "helvetica"
M "$fantasque" "courier new" "monaco" "consolas"
M "$jetmono"   "monospace"

for f in "vera" "dejavu sans"                                   \
         "noto sans" "droid sans" "open sans" "opensans"        \
         "lucida grande" "verdana"; do
    M "$bigsans" "$f"
done
echo "</fontconfig>"

# Local Variables:
# compile-command: "./gen.sh"
# whitespace-line-column: 100
# truncate-lines: t
# End:
