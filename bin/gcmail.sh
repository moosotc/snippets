#!/bin/sh

notmuch search --output=files --format=text0 tag:trash | xargs -0 rm
