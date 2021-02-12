#!/bin/sh

#            _       _ _
#      __  _(_)_ __ (_) |_ _ __ ___
#      \ \/ / | '_ \| | __| '__/ __|
#     _ >  <| | | | | | |_| | | (__
#    (_)_/\_\_|_| |_|_|\__|_|  \___|

#^----- ENVIRONMENT VARIABLES --------------------------------------------------
export MONITOR0="LVDS-1"

export BROWSER="qutebrowser"
export URL_OPENER="dmenuurl.sh"

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
#$

#^----- STARTUP ----------------------------------------------------------------
xrdb ~/.Xresources

ln -sf ${XDG_CONFIG_HOME:-${HOME}/.config}/xmodmap/unicomp.map \
    ${HOME}/.Xmodmap
sleep 1
setxmodmap.sh
xset r rate 300 50
sxhkd &
unclutter --timeout 1 &
fcitx &

~/.config/tmux/default.sh

dunst -always_run_script &
#$

exec bspwm

# vim: fdm=marker fmr=#^,#$
