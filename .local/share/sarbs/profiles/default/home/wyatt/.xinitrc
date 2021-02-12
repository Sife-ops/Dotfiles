#!/bin/sh

#            _       _ _
#      __  _(_)_ __ (_) |_ _ __ ___
#      \ \/ / | '_ \| | __| '__/ __|
#     _ >  <| | | | | | |_| | | (__
#    (_)_/\_\_|_| |_|_|\__|_|  \___|

#^----- ENVIRONMENT VARIABLES --------------------------------------------------
export MONITOR0="HDMI-1"

export BROWSER="qutebrowser"
export URL_OPENER="url.sh"

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
#$

#^----- STARTUP ----------------------------------------------------------------
xrdb ~/.Xresources
ln -sf "${SARBS:-${XDG_DATA_HOME:-${HOME}/.local/share}/sarbs}/waves.jpg" \
    "${WALLPAPER:-${XDG_DATA_HOME:-${HOME}/.local/share}/wallpaper}"
xwallpaper --zoom "${WALLPAPER:-${XDG_DATA_HOME:-${HOME}/.local/share}/wallpaper}"

# ln -sf ${XDG_CONFIG_HOME:-${HOME}/.config}/xmodmap/natty.map \
    # ${HOME}/.Xmodmap
# which setxmodmap.sh && setxmodmap.sh
setxkbmap -option caps:swapescape
xset r rate 200 50
unclutter --timeout 1 &
# fcitx &

dunst -always_run_script &
#$

exec bspwm

# vim: fdm=marker fmr=#^,#$
