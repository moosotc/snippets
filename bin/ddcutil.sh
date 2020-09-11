#!/bin/sh
set -e
. asroot
trap 'test $? != 0 && echo ret=$?' EXIT
p=/dev/i2c-6
if test -c $p && test -w $p; then
    ddcutil $*
else
    modprobe i2c-dev
    chgrp wheel $p
    chmod g+rw $p
    ddcutil $*
fi
