#!/bin/sh

py=$(dirname $0)/3ze.py
for f in "$@"; do
    t=$(basename "$f")
    python $py "$f" "${t%.ttf}-3ze".ttf
done
