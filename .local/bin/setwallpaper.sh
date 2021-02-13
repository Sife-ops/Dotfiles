#!/bin/sh

wallpaper="${WALLPAPER:-${XDG_DATA_HOME:-${HOME}/.local/share}/wallpaper}"
wallpapers="${WALLPAPERS:-${XDG_CACHE_HOME:-${HOME}/.local/share}/wallpapers}"

ln -sf "$1" "$wallpaper"
xwallpaper --zoom "$wallpaper"
