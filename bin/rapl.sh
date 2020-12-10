#!/bin/sh
set -x
. asroot $n
chmod a+r /sys/class/powercap/**/*/energy_uj
