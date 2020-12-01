#!/bin/sh
# move mode

ln -sf ${XDG_CONFIG_HOME:-${HOME}/.config}/sxhkd/dwm/move \
    ${XDG_CONFIG_HOME:-${HOME}/.config}/sxhkd/sxhkdrc
pkill -USR1 -x sxhkd
