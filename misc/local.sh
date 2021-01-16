#!/bin/sh
set -e
b=
f ()
{
    local a=$1
    echo "a is [$a]"
    test -z $2 || {
        echo "exiting $a"
        return
    }
    #a=moo
    f 2 exit
    echo a at exit $a
}

f 1 ""
