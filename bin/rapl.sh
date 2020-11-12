#!/bin/sh
n=${1:-$(id -un)}
. asroot $n
chown $n /sys/devices/virtual/powercap/intel-rapl/intel-rapl*/energy_uj
