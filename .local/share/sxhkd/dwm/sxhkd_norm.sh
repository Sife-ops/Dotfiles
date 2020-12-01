#!/bin/sh
# normal mode

ln -sf ${XDG_CONFIG_HOME:-${HOME}/.config}/sxhkd/dwm/norm \
    ${XDG_CONFIG_HOME:-${HOME}/.config}/sxhkd/sxhkdrc
pkill -USR1 -x sxhkd
