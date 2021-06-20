#!/bin/sh

py=$(dirname $0)/3ze.py
for f in "$@"; do
    t=$(basename "$f")
    python $py -3 -0 -l "$f" "${t%.*}.cff"
done
