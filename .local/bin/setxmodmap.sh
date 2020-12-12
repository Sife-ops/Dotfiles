#!/bin/sh

if which checkdeps.sh >/dev/null 2>&1; then
    checkdeps.sh xcape sexkbmap xmodmap || exit 1; fi

setxkbmap -option
killall -e xcape 1>/dev/null 2>&1

[ "$1" = "default" ] || \
    (xmodmap ${XDG_DATA_HOME:-${HOME}/.local/share}/xmodmap/xmodmap
    xcape -e 'Control_L=Escape;Control_R=BackSpace' &)
