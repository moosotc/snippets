#!/bin/sh

exec 2>/tmp/xinit.err
exec 1>/tmp/xinit.out

xrandr --dpi 152x152

#setxkbmap -option "terminate:ctrl_alt_bksp"
xset dpms 600 1200 2400
xset +dpms
setcapskey
xmodmap -e 'pointer = 3 2 1'
xrdb -merge $HOME/.Xdefaults

xsetroot -solid '#63718c'
tmux new-session -s yt -d
mkfifo /tmp/i3.fifo
test ! -e /tmp/noi3 && {
    rxvtd -q -o -f
    i3monwins >/tmp/i3.fifo  & disown
    exec i3
} || {
    exec xterm -fa mono-13
}
