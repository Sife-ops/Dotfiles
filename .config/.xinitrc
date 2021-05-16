#!/bin/sh

#            _       _ _
#      __  _(_)_ __ (_) |_ _ __ ___
#      \ \/ / | '_ \| | __| '__/ __|
#     _ >  <| | | | | | |_| | | (__
#    (_)_/\_\_|_| |_|_|\__|_|  \___|

#---- ENVIRONMENT VARIABLES ----------------------------------------------------

export BROWSER="chromium"
export URL_OPENER="url.sh"

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

#---- STARTUP ------------------------------------------------------------------

xmodmap="${XMODMAPS}/$(cat /etc/hostname)"
if [ -f "$xmodmap" ]; then
    ln -sf "$xmodmap" "$XMODMAP"
    sleep 1
    setxmodmap.sh
fi

ln -sf ${XDG_CONFIG_HOME}/sxhkd/xfce4 \
    ${XDG_CONFIG_HOME}/sxhkd/sxhkdrc
sxhkd &

exec startxfce4

# vim: fdm=marker fmr=#^,#$
