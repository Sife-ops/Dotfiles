#!/bin/sh

wallpaper="${WALLPAPER:-${XDG_DATA_HOME:-${HOME}/.local/share}/wallpaper}"
wallpaper_cache="${WALLPAPER_CACHE:-${XDG_CACHE_HOME:-${HOME}/.cache}/wallpaper}"

cp "$1" "$wallpaper_cache"
xwallpaper --zoom "$wallpaper"
