#!/bin/sh

py=$(dirname $0)/3ze.py
for f in "$@"; do
    t=$(basename "$f")
    python $py -3 -l -0 "$f" ze3-$t
done
