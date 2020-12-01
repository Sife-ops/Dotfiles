#!/bin/sh
# turn on bspwm preselect mode

ln -sf ${XDG_CONFIG_HOME:=${HOME}/.config}/sxhkd/bspwm/presel \
    ${XDG_CONFIG_HOME:=${HOME}/.config}/sxhkd/sxhkdrc
pkill -USR1 -x sxhkd
