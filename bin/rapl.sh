#!/bin/sh
set -x
n=${1:-$(id -u)}
. asroot $n
chown $n /sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/intel-rapl:*/energy_uj
