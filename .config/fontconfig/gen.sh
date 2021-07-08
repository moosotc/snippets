#!/bin/sh
# works with fontconfig version 2.13.93
set -eu

# export FONTCONFIG_FILE=$HOME/.config/fontconfig/fonts.conf
# prior to starting X to get reproducible distribution-independent behavior

# https://eev.ee/blog/2015/05/20/i-stared-into-the-fontconfig-and-the-fontconfig-stared-back-at-me/

# montserrat alternates https://github.com/JulietaUla/Montserrat
# fantasque sans mono   https://github.com/belluzj/fantasque-sans
# ubuntu                https://design.ubuntu.com/font/
# noto sans             https://noto-website-2.storage.googleapis.com/pkgs/NotoSans-unhinted.zip
# noto serif            https://noto-website-2.storage.googleapis.com/pkgs/NotoSerif-unhinted.zip
# jetbrains mono        https://github.com/JetBrains/JetBrainsMono

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
      <string>jetbrains mono</string>
    </edit>
  </match>
EOF

mono0="ubuntu mono"
mono2="jetbrains mono"
sans1="noto sans"
sans2="montserrat alternates"
serif="noto serif"
fallb="Last Resort High-Efficiency"

M "$sans1" "opensans" "open sans" "noto sans" "droid sans"
M "$sans1" "sans" "sans-serif"
M "$mono0" "mono0 ""courier new" "monaco" "consolas"
M "$mono2" "monospace" "bitstream vera sans mono"
M "$sans2" "vera" "lucida grande" "verdana"
M "$serif" "serif"
M "$fallb" "fallback"

echo "</fontconfig>"

# Local Variables:
# compile-command: "./gen.sh"
# whitespace-line-column: 100
# truncate-lines: t
# End:
