#!/bin/sh
# turn on bspwm resize mode

ln -sf ${XDG_CONFIG_HOME:=${HOME}/.config}/sxhkd/bspwm/resize \
    ${XDG_CONFIG_HOME:=${HOME}/.config}/sxhkd/sxhkdrc
pkill -USR1 -x sxhkd
