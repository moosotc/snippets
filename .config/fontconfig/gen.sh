#!/bin/sh

# export FONTCONFIG_FILE=$HOME/.config/fontconfig/fonts.conf
# prior to starting X to get reproducible distribution independent behavior

# https://eev.ee/blog/2015/05/20/i-stared-into-the-fontconfig-and-the-fontconfig-stared-back-at-me/

test -z $1 && exec >${FONTCONFIG_FILE-$HOME/.config/fontconfig/fonts.conf}
S() {
    cat <<EOF
  <match target="pattern">
    <test qual="any" name="family"><string>$1</string></test>
    <edit name="family" mode="assign" binding="strong">
EOF
    shift
    for f in "$@"; do
        printf "      <string>$f</string>\n"
    done
    cat <<EOF
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
S "serif"           "pt astra serif"
S "monospace"       "iosevka malc"

for f in "sans" "sans-serif" "arial" "helvetica" "cnn";
do
    S "$f" "xo oriel"
done

S "times new roman" "xo thames"
S "calibri"         "xo caliburn"
S "trebuchet ms"    "xo trebizond" "fontin sans cr"
S "tahoma"          "xo tahion"    "montserrat alternates"
S "verdana"         "xo verbena"   "montserrat alternates"

S "georgia"         "merriweather"
S "segoe ui"        "alegreya sans"  # github, channel9
S "consolas"        "iosevka malc"

S "ui"              "pt sans"
S "monaco"          "monofur"

for f in "segoe"                                \
         "optima"                               \
         "candara"                              \
         "cambria"                              \
         "constantia"                           \
         "corbel"                               \
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
         "bitstream vera sans"                  \
         "lucida"                               \
         "lucida grande"                        \
         "dejavu sans"
do
    S "$f" "montserrat alternates"
done

# large x-height serif
for f in "droid serif" "noto serif" "dejavu serif";
do
    S "$f" "pt serif"
done

# used....
S "cantarell" "pt astra sans"
S "comic sans ms" "alegreya sans"

echo "</fontconfig>"

# Local Variables:
# compile-command: "./gen.sh"
# whitespace-line-column: 100
# truncate-lines: t
# End:
