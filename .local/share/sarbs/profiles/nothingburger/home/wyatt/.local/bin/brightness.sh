#!/bin/sh
# change monitor brightness

if [ $# -ne 2 ] ; then
    echo "Usage: ${0##/*/} <inc|dec> <increment>"
    exit 1
fi

bl="/sys/class/backlight/intel_backlight/brightness"
br=$(cat $bl)

echo "brightness is $br"

case $1 in
    inc )
        br_new=$(( $br + $2 ))
        echo "trying to change brightness to $br_new"
        if [ $br_new -ge 482 ] ; then
            echo "cannot go above maximum brightness"
            echo '482' > $bl
        else
            echo "$br_new" > $bl
        fi
        ;;

    dec )
        br_new=$(( $br - $2 ))
        echo "trying to change brightness to $br_new"
        if [ $br_new -le 100 ] ; then
            echo "cannot go below minimum brightness"
            echo '100' > $bl
        else
            echo "$br_new" > $bl
        fi
        ;;
esac
