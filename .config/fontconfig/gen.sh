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
S "serif"           "alegreya"
S "sans-serif"      "xo oriel"
S "monospace"       "iosevka malc"
S "arial"           "xo oriel"
S "trebuchet ms"    "fontin sans cr"
S "corbel"          "vollkorn"
S "times new roman" "xo thames"
S "calibri"         "xo caliburn"
S "courier new"     "xo courser"
S "ui"              "pt sans"
S "georgia"         "merriweather"
segoeui="montserrat alternates"
#segoeui="pt sans"
S "segoe ui"        $segoeui # github, channel9
S "consolas"        "iosevka malc"
S "monaco"          "monofur"
S "helvetica"       "xo oriel"
S "helvetica neue"  "vollkorn"
S "cantarell"       "pt sans"
S "optima"          "alegreya sans sc"

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
         "bitstream vera sans"                  \
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
for f in "comic sans ms"
do
    # respect your elders + z ftw
    S "$f" "ruslan display"
done

echo "</fontconfig>"

# Local Variables:
# compile-command: "./gen.sh"
# whitespace-line-column: 100
# truncate-lines: t
# End:
