#!/bin/sh

wallpaper="${WALLPAPER:-${XDG_DATA_HOME:-${HOME}/.local/share}/wallpaper}"

ln -sf "$(readlink -f $1)" "$wallpaper"
xwallpaper --zoom "$wallpaper"
