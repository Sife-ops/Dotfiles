#!/bin/sh
# set up keyboard stuff

if which checkdeps.sh >/dev/null 2>&1; then
    checkdeps.sh xcape setxkbmap xmodmap || exit 1; fi

setxkbmap -option
killall -e xcape 1>/dev/null 2>&1

[ "$1" = "default" ] || \
    (xmodmap ~/.Xmodmap
    xcape -e 'Alt_L=Tab;Control_L=Escape;Alt_R=backslash;Control_R=BackSpace' &)

xset r rate 300 50
