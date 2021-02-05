#!/bin/sh

#            _       _ _
#      __  _(_)_ __ (_) |_ _ __ ___
#      \ \/ / | '_ \| | __| '__/ __|
#     _ >  <| | | | | | |_| | | (__
#    (_)_/\_\_|_| |_|_|\__|_|  \___|

#^----- ENVIRONMENT VARIABLES --------------------------------------------------
#^----- MONITORS ---------------------------------------------------------------
export MONITOR0="DP-1"
export MONITOR1="HDMI-1"
#$

#^----- BROWSER ----------------------------------------------------------------
export BROWSER="librewolf"
#$

#^----- URL --------------------------------------------------------------------
export URL_OPENER="dmenuurl.sh"
#$

#^----- IM ---------------------------------------------------------------------
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
which fcitx && fcitx &
#$ #$

#^----- KEYMAP -----------------------------------------------------------------
# ln -sf ${XDG_CONFIG_HOME:-${HOME}/.config}/xmodmap/natty.map \
    # ${HOME}/.Xmodmap
# which setxmodmap.sh && setxmodmap.sh
which xset && xset r rate 300 50
which sxhkd && sxhkd &
which unclutter && unclutter --timeout 1 &
#$

#^----- GPG --------------------------------------------------------------------
password.sh -b ipfs
offlineimap &
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
