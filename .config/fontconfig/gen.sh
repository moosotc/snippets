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

test -n "$(find $HOME/.fonts -name LucidaSansRegular.ttf)" && {
    lucida="Lucida Sans"
} || {
    lucida="xo verbena"
}

# PT              https://en.wikipedia.org/wiki/PT_Fonts
# XO              https://fonts.myoffice.ru
# SIL             https://software.sil.org/
# Merriweather    https://ebensorkin.wordpress.com/
# Iosevka         https://github.com/be5invis/Iosevka
#                 https://github.com/moosotc/snippets/blob/master/bin/doiosevka
# Monofur         http://eurofurence.net/monofur.html
# Unifraktur      http://unifraktur.sourceforge.net/maguntia.html
# Lucida          https://en.wikipedia.org/wiki/Lucida
#                 https://docs.oracle.com/javase/7/docs/technotes/guides/intl/font.html
# URW++           https://en.wikipedia.org/wiki/URW%2B%2B
#                 https://github.com/ArtifexSoftware/urw-base35-fonts
# Montseratt      https://github.com/JulietaUla/Montserrat

S "mono"            "monospace"
S "sans"            "sans-serif"
S "serif"           "pt serif"
S "sans-serif"      "xo oriel"
S "monospace"       "iosevka malc"
S "mono"            "iosevka malc"
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
S "segoe ui"        "montseratt" # github, channel9
S "monaco"          "monofur"
S "helvetica"       "xo oriel"
S "helvetica neue"  "montserrat" # https://adtmag.com/articles/2018/03/21/java-10.aspx
test "Lucida Sans" = "$lucida" && true || S "lucida sans" "$lucida"
S "lucida grande"   "$lucida"
S "lucida sans unicode" "$lucida"

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
         "opensans"                             \
         "droid sans"                           \
         "noto sans"                            \
         "dejavu sans";
do
    S "$f" "xo verbena"
done

# large x-height serif
for f in "droid serif" "noto serif" "dejavu serif";
do
    S "$f" "p052"
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
