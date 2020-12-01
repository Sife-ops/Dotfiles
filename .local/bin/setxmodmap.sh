#!/bin/sh

if which checkdeps.sh >/dev/null; then
    if ! checkdeps.sh xcape setxkbmap xmodmap; then exit 1; fi fi

setxkbmap -option
killall -e xcape 1>/dev/null 2>&1

[ "$1" = "default" ] || \
    (xmodmap ${XDG_DATA_HOME:-${HOME}/.local/share}/xmodmap/xmodmap
    xcape -e 'Control_L=Escape;Control_R=BackSpace' &)
