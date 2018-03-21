#!/bin/sh
set -e

test "$1" = "-" && {
    id=$(xdotool getactivewindow) || echo fsck
    out=${2-/tmp/shot.png}
} || {
    out=${1-/tmp/shot.png}
    set -- $(xwininfo -root | grep "Window id:")
    id=$4
}

eval $(xdotool windowactivate $id getwindowgeometry --shell $id) || true
ffmpeg -hide_banner -loglevel error                                          \
       -video_size "${WIDTH}x${HEIGHT}"                                      \
       -y -f x11grab -i $DISPLAY.$SCREEN+$X,$Y -vframes 1 "$out" || echo wtf
