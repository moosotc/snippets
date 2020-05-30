#!/bin/sh

for f in "$@"; do
    t=$(basename "$f")
    python 3ze.py "$f" "${t%.ttf}-3ze".ttf
done
