#!/bin/sh
set -e
test "$1" = "-" && {
    id=$(xdotool getactivewindow)
    shift
} || id=$(xdotool selectwindow)

eval $(xdotool windowactivate $id getwindowgeometry --shell $id)
ffmpeg -hide_banner -loglevel panic \
       -video_size "${WIDTH}x${HEIGHT}" \
       -y -f x11grab -i $DISPLAY.$SCREEN+$X,$Y "$1"
