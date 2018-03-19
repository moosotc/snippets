#!/bin/sh
find $PWD -type f | while read f; do
    fc-scan -f '%{spacing}:\n' $f | grep -q '^[^:]' && echo $f
done | while read f; do llppac -t font $f; done
