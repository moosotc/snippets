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

S "mono"            "monospace"
S "sans"            "sans-serif"
S "serif"           "pt astra serif"
S "sans-serif"      "xo oriel"
S "monospace"       "iosevka malc"
S "arial"           "xo oriel"
S "trebuchet ms"    "pt sans"
S "corbel"          "volkorn"
S "times new roman" "xo thames"
S "calibri"         "xo caliburn"
S "courier new"     "xo courser"
S "ui"              "pt sans"
S "georgia"         "merriweather"
S "segoe ui"        "pt sans"   # github, channel9
S "consolas"        "iosevka malc"
S "monaco"          "monofur"
S "helvetica"       "xo oriel"
S "helvetica neue"  "vollkorn"

for f in "segoe"                                \
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
         "opensans"                             \
         "droid sans"                           \
         "noto sans"                            \
         "lucida"                               \
         "lucida grande"                        \
         "verdana"                              \
         "tahoma"                               \
         "dejavu sans";
do
    S "$f" "montserrat alternates"
done

# large x-height serif
for f in "droid serif" "noto serif" "dejavu serif";
do
    S "$f" "pt serif"
done

# gnome/gtk, comic
for f in "cantarell" "comic sans ms"
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
