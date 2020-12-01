#!/bin/sh
# turn on bspwm gaps mode

ln -sf ${XDG_CONFIG_HOME:=${HOME}/.config}/sxhkd/bspwm/gaps \
    ${XDG_CONFIG_HOME:=${HOME}/.config}/sxhkd/sxhkdrc
pkill -USR1 -x sxhkd
