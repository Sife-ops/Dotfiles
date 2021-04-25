#!/bin/sh

#            _       _ _
#      __  _(_)_ __ (_) |_ _ __ ___
#      \ \/ / | '_ \| | __| '__/ __|
#     _ >  <| | | | | | |_| | | (__
#    (_)_/\_\_|_| |_|_|\__|_|  \___|

#---- ENVIRONMENT VARIABLES ----------------------------------------------------

export BROWSER="librewolf"
export URL_OPENER="url.sh"

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

#---- STARTUP ------------------------------------------------------------------

xrdb ~/.Xresources

xmodmap="${XMODMAPS}/$(cat /etc/hostname)" # need os detection
if [ -f "$xmodmap" ]; then
    ln -sf "$xmodmap" "$XMODMAP"
    sleep 1
    setxmodmap.sh
fi

ln -sf ${XDG_CONFIG_HOME}/sxhkd/xfce4 \
    ${XDG_CONFIG_HOME}/sxhkd/sxhkdrc
sxhkd &

ln -sf ${HOME}/.local/bin/menus_dmenu/* ${HOME}/.local/bin/

dunst &
pacmannotify.sh 3600 &
unclutter --timeout 1 &

exec startxfce4

# vim: fdm=marker fmr=#^,#$
