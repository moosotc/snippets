#!/bin/sh

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
  </match>
EOF

S "serif"           "pt serif"
S "sans"            "lato"
S "sans-serif"      "lato"
S "mono"            "pt mono"
S "monospace"       "pt mono"
S "arial"           "xo oriel"
S "verdana"         "open sans"
S "trebuchet ms"    "xo trebizond"
S "tahoma"          "xo tahion"
S "times new roman" "xo thames"
S "calibri"         "xo caliburn"
S "courier new"     "xo courser"
S "comic sans ms"   "andika"
S "cantarell"       "pt sans"
S "ui"              "pt sans"
S "georgia"         "gentium plus"
S "dejavu sans"     "ibm plex sans"
S "dejavu serif"    "ibm plex serif"
S "consolas"        "ibm plex mono"
S "segoe ui"        "ibm plex sans" # github
S "monaco"          "monofur"       # forums
S "helvetica"       "roboto"        # bbc.co.uk
S "helvetica neue"  "roboto slab"

for f in "segoe"                                \
         "corbel"                               \
         "candara"                              \
         "cambria"                              \
         "constantia"                           \
         "linux libertine"                      \
         "helvetica neue"
         do
    S "$f" "xo symbol"
done
echo "</fontconfig>"

# Local Variables:
# compile-command: "./gen.sh"
# End:
