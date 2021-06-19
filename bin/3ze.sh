#!/bin/sh

py=$(dirname $0)/3ze.py
for f in "$@"; do
    t=$(basename "$f")
    python $py -I -0 -3 "$f" "${t%.*}-leg".otf
done
