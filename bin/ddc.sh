#!/bin/sh

. asroot
set -e
trap 'test $? != 0 && echo ret=$?' EXIT
n=6
p=/dev/i2c-$n
test -c $p || modprobe i2c-dev
test -w $p || {
    chgrp wheel $p
    chmod g+rw $p
}
exec ddcutil --bus 6 $*
