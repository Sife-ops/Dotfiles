#!/bin/sh
# set up keyboard stuff

checkdeps.sh xcape setxkbmap xmodmap

setxkbmap -option
killall -e xcape 1>/dev/null 2>&1

if [ ! "$1" = "default" ]; then
    xmodmap "$XMODMAP"
    xcape -e 'Alt_L=Tab;Control_L=Escape;Alt_R=backslash;Control_R=BackSpace' &
fi

xset r rate 300 50
