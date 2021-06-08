#!/bin/sh
mpv --demuxer-rawvideo-w=1280                                   \
    --demuxer-rawvideo-h=1024                                   \
    --demuxer=rawvideo /dev/zero                                \
    --sub-file=$(dirname $0)/../misc/srt-font-styles.srt
