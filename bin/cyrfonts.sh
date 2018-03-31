#!/bin/sh

for f in $(fc-scan -f "%{file}:%{lang}\n" . | grep \|ru); do
    echo $f
done | cut -d: -f1
