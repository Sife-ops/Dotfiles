#!/bin/sh
# resize mode

ln -sf ${XDG_CONFIG_HOME:-${HOME}/.config}/sxhkd/dwm/resize \
    ${XDG_CONFIG_HOME:-${HOME}/.config}/sxhkd/sxhkdrc
pkill -USR1 -x sxhkd
