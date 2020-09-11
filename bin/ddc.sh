#!/bin/sh

. asroot
set -ex
trap 'test $? != 0 && echo ret=$?' EXIT
n=6
p=/dev/i2c-$n
test -c $p || modprobe i2c-dev
chgrp wheel $p
chmod g+rw $p
