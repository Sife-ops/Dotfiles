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

if [ ! -f "$WALLPAPER" ]; then
    ln -sf "$WALLPAPERS/waves.jpg" "$WALLPAPER"
fi
xwallpaper --zoom "$WALLPAPER"

xset r rate 200 50
unclutter --timeout 1 &
dunst -always_run_script &
#$

. "${XDG_CONFIG_HOME:-${HOME}/.config}/xinitrc"

# vim: fdm=marker fmr=#^,#$
