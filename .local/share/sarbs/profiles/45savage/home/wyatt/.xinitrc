#!/bin/sh

#            _       _ _
#      __  _(_)_ __ (_) |_ _ __ ___
#      \ \/ / | '_ \| | __| '__/ __|
#     _ >  <| | | | | | |_| | | (__
#    (_)_/\_\_|_| |_|_|\__|_|  \___|

#^----- ENVIRONMENT VARIABLES --------------------------------------------------
# export MONITOR0="HDMI-1"
# export MONITOR1=""

export BROWSER="qutebrowser"
export URL_OPENER="url.sh"

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
#$

#^----- STARTUP ----------------------------------------------------------------
xrandr --output HDMI-1 --mode 1920x1080
xrdb ~/.Xresources

# ln -sf ${XDG_CONFIG_HOME:-${HOME}/.config}/X11/xmodmap/k400.map \
    # ${HOME}/.Xmodmap
# setxmodmap.sh
setxkbmap -option caps:swapescape
xset r rate 300 50
sxhkd &
unclutter --timeout 1 &
# fcitx &

dunst -always_run_script &
#$

exec bspwm

# vim: fdm=marker fmr=#^,#$
