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
  </match>
EOF

S "serif"           "pt serif"  # https://en.wikipedia.org/wiki/PT_Fonts
S "sans"            "lato"      # http://www.latofonts.com/lato-free-fonts/
S "sans-serif"      "lato"
S "mono"            "pt mono"
S "monospace"       "pt mono"
S "arial"           "xo oriel"  # https://fonts.myoffice.ru/
S "verdana"         "open sans" # https://fonts.google.com/specimen/Open+Sans
S "trebuchet ms"    "xo trebizond"
S "tahoma"          "xo tahion"
S "times new roman" "xo thames"
S "calibri"         "xo caliburn"
S "courier new"     "xo courser"
S "comic sans ms"   "andika"    # https://software.sil.org/andika/
S "cantarell"       "pt sans"
S "ui"              "pt sans"
S "georgia"         "gentium plus" # https://software.sil.org/gentium/
S "dejavu sans"     "ibm plex sans" # https://en.wikipedia.org/wiki/IBM_Plex
S "dejavu serif"    "ibm plex serif"
S "consolas"        "ibm plex mono"
S "segoe ui"        "ibm plex sans" # github
S "monaco"          "monofur"       # http://eurofurence.net/monofur.html
                                    # (some forums)
S "helvetica"       "roboto"        # https://fonts.google.com/specimen/Roboto
                                    # (bbc.co.uk)
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
