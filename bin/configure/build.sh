#!/bin/sh
cd $HOME/x/rcs/git/fonts/Iosevka
npm run build -- ttf-unhinted::iosevka-clam | cat
#echo
#echo completed
#npm run build -- ttf-unhinted::iosevka-clam | cat
