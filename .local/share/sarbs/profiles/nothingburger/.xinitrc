#!/bin/sh

#            _       _ _
#      __  _(_)_ __ (_) |_ _ __ ___
#      \ \/ / | '_ \| | __| '__/ __|
#     _ >  <| | | | | | |_| | | (__
#    (_)_/\_\_|_| |_|_|\__|_|  \___|

#^----- ENVIRONMENT VARIABLES --------------------------------------------------
#^----- MONITORS ---------------------------------------------------------------
export MONITOR0="LVDS-1"
export MONITOR1=""
#$

#^----- IM ---------------------------------------------------------------------
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
which fcitx && fcitx &
#$

#^----- URL --------------------------------------------------------------------
export URL_OPENER="dmenuurl.sh"
#$ #$

#^----- KEYMAP -----------------------------------------------------------------
ln -sf ${XDG_CONFIG_HOME:-${HOME}/.config}/xmodmap/mac.map \
    ${HOME}/.Xmodmap
sleep 1
setxmodmap.sh
xset r rate 300 50
sxhkd &
unclutter --timeout 1 &
#$

#^----- TMUX -------------------------------------------------------------------
~/.config/tmux/default.sh
#$

#^----- XRESOURCES -------------------------------------------------------------
xrdb ~/.Xresources
#$

#^----- WM ---------------------------------------------------------------------
exec bspwm
#$

# vim: fdm=marker fmr=#^,#$
