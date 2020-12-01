#!/bin/sh
# turn on bspwm normal mode

ln -sf ${XDG_CONFIG_HOME:=${HOME}/.config}/sxhkd/bspwm/norm \
    ${XDG_CONFIG_HOME:=${HOME}/.config}/sxhkd/sxhkdrc
pkill -USR1 -x sxhkd
