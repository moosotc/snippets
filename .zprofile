XPATH=${MALC_ZPATH-$PATH}

PATH=/net/bin
PATH=$PATH:$HOME/bin:$XPATH

EDITOR=emacsclient
INFOPATH=$HOME/share/info:/net/share/info
PKG_CONFIG_PATH=/net/share/pkgconfig
PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/net/lib/pkgconfig
PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/lib/pkgconfig
PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/share/pkgconfig

TERMINFO=/net/share/terminfo

CPATH=/net/include

LIBRARY_PATH=/net/lib
ACLOCAL_PATH=$ACLOCAL_PATH:/net/share/aclocal

MANPATH=/net/man:/net/share/man:/usr/man:/usr/share/man
MANPATH=$MANPATH:$HOME/man

LC_CTYPE=ru_RU.utf8
LC_TIME=en_GB

export PATH MANPATH LIBRARY_PATH PKG_CONFIG_PATH EDITOR
export INFOPATH CPATH ACLOCAL_PATH LC_CTYPE LC_TIME TERMINFO
export MALC_ZPATH="$XPATH"
export CDPATH=.:$HOME/x
export FONTCONFIG_FILE=$HOME/xsrc/snippets/.config/fontconfig/fonts.conf
export MC_XDG_OPEN=$HOME/xsrc/snippets/bin/mopen

yy() { exec xinit "$*"; }

# https://github.com/NixOS/nixpkgs/issues/16327
export NO_AT_BRIDGE=1
