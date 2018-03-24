#!/bin/sh

# export FONTCONFIG_FILE=$HOME/.config/fontconfig/fonts.conf
# prior to starting X to get reproducible distribution independent behavior

test -z $1 && exec >${FONTCONFIG_FILE-$HOME/.config/fontconfig/fonts.conf}
S() {
    cat <<EOF
  <match target="pattern">
    <test qual="any" name="family"><string>$1</string></test>
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
EOF

# PT           https://en.wikipedia.org/wiki/PT_Fonts
# Exo 2        https://fonts.google.com/specimen/Exo+2
# XO           https://fonts.myoffice.ru
# SIL          https://software.sil.org/
# Merriweather https://ebensorkin.wordpress.com/
# Iosevka      https://github.com/be5invis/Iosevka
#              https://github.com/moosotc/snippets/blob/master/bin/doiosevka
# Monofur      http://eurofurence.net/monofur.html
# IBM Plex     https://en.wikipedia.org/wiki/IBM_Plex
# Unifraktur   http://unifraktur.sourceforge.net/maguntia.html

S "serif"           "pt serif"
S "sans"            "exo 2"
S "sans-serif"      "exo 2"
S "mono"            "iosevka malc"
S "monospace"       "iosevka malc"
S "arial"           "xo oriel"
S "verdana"         "xo verbena"
S "trebuchet ms"    "xo trebizond"
S "tahoma"          "xo tahion"
S "times new roman" "xo thames"
S "calibri"         "xo caliburn"
S "courier"         "xo courser"
S "courier new"     "xo courser"
S "comic sans ms"   "andika"
S "ui"              "pt sans"
S "georgia"         "merriweather"
S "consolas"        "iosevka malc"
S "segoe ui"        "exo 2"                                   # github
S "monaco"          "monofur"
S "helvetica"       "xo oriel"

for f in "segoe"                                \
         "corbel"                               \
         "candara"                              \
         "cambria"                              \
         "constantia"                           \
         "linux libertine"
do
    # learn yourself some greek
    S "$f" "xo symbol"
done

# large x-height sans
for f in "bitstream vera sans"                  \
         "open sans"                            \
         "droid sans"                           \
         "noto sans"                            \
         "lucida grande"                        \
         "lucida sans unicode"                  \
         "dejavu sans";
do
    S "$f" "xo verbena"
done

# large x-height serif
for f in "droid serif" "noto serif" "dejavu serif";
do
    S "$f" "ibm plex serif"
done

# gnome/gtk
for f in "cantarell"
do
    # respect your elders + z ftw
    S "$f" "UnifrakturMaguntia21"
done

echo "</fontconfig>"

# Local Variables:
# compile-command: "./gen.sh"
# whitespace-line-column: 100
# truncate-lines: t
# End:
