#!/bin/sh
set -e
exec 2>/tmp/xinit.err
exec 1>/tmp/xinit.out

#setxkbmap -option "terminate:ctrl_alt_bksp"
xset dpms 600 1200 2400
xset +dpms
xrdb -load $HOME/.config/Xresources
setcapskey
setdpi
setpointer || true
#setmenusuper
#xsetroot -solid '#63718c'
xsetroot -solid '#43616c'
#xsetroot -solid 'grey21'
tmux new-session -s yt -d || true
test -p /tmp/i3.fifo || mkfifo /tmp/i3.fifo
test ! -e /tmp/noi3 && {
    rxvtd -q -o -f
    exec i3
} || {
    exec rxvt -fn xft:mono-10 -rv
}
