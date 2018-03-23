#!/bin/sh
set -e

path=${1-$PWD}
find $path -type f | while read f; do
    o=$(fc-scan "$f" -f "f='%{family}' s='%{spacing}' p='%{file}'") && {
        eval $o
        test -n "$s" -a -e "$p" -a -r "$p" && echo $p || true
    }
done
