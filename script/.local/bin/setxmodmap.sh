#!/bin/sh
# initialize keymaps

setxkbmap -option
# killall -e xcape 1>/dev/null 2>&1

if [ ! "$1" = "default" ]; then
    # setxkbmap -option caps:escape
    # xcape -e 'Alt_L=Tab;Control_L=Escape;Alt_R=backslash;Control_R=BackSpace' &
    xmodmap "$XMODMAP"
fi

# xset r rate 300 50
