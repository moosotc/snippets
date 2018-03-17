#!/bin/sh

test -z $1 && exec >${FONTCONFIG_FILE-$HOME/.config/fontconfig/fonts.conf}
s() {
    cat <<EOF
  <alias>
    <family>$1</family>
    <accept><family>$2</family></accept>
  </alias>
EOF
}

cat <<EOF
<?xml version='1.0'?>
<!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
<fontconfig>
  <dir>~/.fonts</dir>
  <match>
    <edit name="color"><bool>false</bool></edit>
    <edit name="hinting"><bool>false</bool></edit>
  </match>
EOF

s serif "pt serif"
s sans-serif lato
s monospace "pt mono"
s arial "xo oriel"
s verdana "xo verbena"
s "open sans" "xo verbena"
s "trebuchet ms" "xo trebizond"
s tahoma "xo tahion"
s "timnes new roman" "xo thames"
s calibri "xo caliburn"
s "courier new" "xo courser"
s cantarell "pt sans"
s consolas inconsolata
s ui "pt sans"
s "comic sans ms" andika
echo "</fontconfig>"

# Local Variables:
# compile-command: "./gen.sh"
# End:
