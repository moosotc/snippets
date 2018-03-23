#!/bin/sh
set -e

path=${1-$PWD}
find $path -type f | while read f; do
    o=$(fc-scan "$f" -f 'f=\"%{family}\" s=\"%{spacing}\" p=\"%{file}\"') && {
        eval "$o"
        test -z $s || echo "$f=$p"
    }
done
