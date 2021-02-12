#!/bin/sh

#            _       _ _
#      __  _(_)_ __ (_) |_ _ __ ___
#      \ \/ / | '_ \| | __| '__/ __|
#     _ >  <| | | | | | |_| | | (__
#    (_)_/\_\_|_| |_|_|\__|_|  \___|

#^----- ENVIRONMENT VARIABLES --------------------------------------------------
export MONITOR0="DP-1"
export MONITOR1="HDMI-1"

export BROWSER="qutebrowser"
export URL_OPENER="url.sh"

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
#$

#^----- STARTUP ----------------------------------------------------------------
xrdb ~/.Xresources

# ln -sf ${XDG_CONFIG_HOME:-${HOME}/.config}/xmodmap/natty.map \
    # ${HOME}/.Xmodmap
# which setxmodmap.sh && setxmodmap.sh
xset r rate 200 50
sxhkd &
unclutter --timeout 1 &
fcitx &

~/.config/tmux/default.sh

dunst -always_run_script &

password.sh
offlineimap &
#$

exec bspwm

# vim: fdm=marker fmr=#^,#$
