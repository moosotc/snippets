#!/bin/sh
set -e

exec ~/x/rcs/git/alttab/src/alttab -w 1 -i 0x0 -t 512x64        \
     -sc 1 -s 1 -font 'xft:iosevka malc-9'
