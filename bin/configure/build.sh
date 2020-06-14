#!/bin/sh
cd $HOME/x/rcs/git/fonts/Iosevka
exec npm run build -- ttf-unhinted::iosevka-clam | cat
