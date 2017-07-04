#!/bin/sh

exec 2>/tmp/xinit.err
exec 1>/tmp/xinit.out

xrandr --dpi 152x152

xset dpms 600 1200 2400
xset +dpms
setcapskey
xmodmap -e 'pointer = 3 2 1'
xrdb -merge $HOME/.Xdefaults

xsetroot -solid '#63718c'
tmux new-session -s yt -d
mkfifo /tmp/i3.fifo
true && {
    tint2 & disown
    exec i3
} || {
    exec st -f mooterm-14
}
