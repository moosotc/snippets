#!/bin/sh

exec 2>/tmp/xinit.err
exec 1>/tmp/xinit.out

xrandr --dpi 152x152
SUDO_ASKPASS=$HOME/bin/askpass sudo dmesg -C >/tmp/dmesg

xset dpms 600 1200 2400
xset +dpms
setcapskey
xmodmap -e 'pointer = 3 2 1'
xrdb -merge $HOME/.Xdefaults

compton --backend glx -D 1 -b
hsetroot -solid '#63718c'
tmux new-session -d
mkfifo /tmp/i3.fifo
tint2 & disown
exec i3
