#!/bin/sh

#            _       _ _
#      __  _(_)_ __ (_) |_ _ __ ___
#      \ \/ / | '_ \| | __| '__/ __|
#     _ >  <| | | | | | |_| | | (__
#    (_)_/\_\_|_| |_|_|\__|_|  \___|

#---- ENVIRONMENT VARIABLES ----------------------------------------------------

# export MONITOR0="HDMI-0"

export BROWSER="librewolf"
export URL_OPENER="url.sh"

# needed?
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

#---- STARTUP ------------------------------------------------------------------

xrdb ~/.Xresources

# if [ ! -f "$WALLPAPER" ]; then
#     ln -sf "$WALLPAPERS/waves.jpg" "$WALLPAPER"
# fi
# xwallpaper --zoom "$WALLPAPER"

xmodmap="${XMODMAPS}/$(cat /etc/hostname)" # os detection
if [ -f "$xmodmap" ]; then
    ln -sf "$xmodmap" "$XMODMAP"
    sleep 1
    setxmodmap.sh
fi

ln -sf ${HOME}/.local/bin/menus_dmenu/* ${HOME}/.local/bin/

# xset r rate 200 50
unclutter --timeout 1 &
# dunst -always_run_script &

ln -sf ${XDG_CONFIG_HOME}/sxhkd/xfce4 \
    ${XDG_CONFIG_HOME}/sxhkd/sxhkdrc
sxhkd &

exec startxfce4

# . "${XDG_CONFIG_HOME}/xinitrc"

# vim: fdm=marker fmr=#^,#$
