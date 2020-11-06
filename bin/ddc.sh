#!/bin/sh
set -e
trap 'test $? != 0 && echo ret=$?' EXIT

n=6
p=/dev/i2c-$n
test -c $p || {
    sudo modprobe i2c-dev
    sudo chgrp wheel $p
    sudo chmod g+rw $p
}
exec ddcutil --bus 6 $*
