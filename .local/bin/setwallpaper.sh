#!/bin/sh

wallpaper="${WALLPAPER:-${XDG_DATA_HOME:-${HOME}/.local/share}/wallpaper}"

if [ -n "$1" ]; then
    ln -sf "$(readlink -f $1)" "$wallpaper"
fi

xwallpaper --zoom "$wallpaper"
