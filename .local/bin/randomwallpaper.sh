#!/bin/sh

wallpapers="${WALLPAPERS:-${XDG_DATA_HOME:-${HOME}/.local/share}/wallpapers}"

while true; do
    setwallpaper.sh "$(find "$wallpapers" -type f | shuf | head -n 1)"
    if [ -n "$1" ]; then
        sleep "$(( $1 * 60 ))"
    else
        break
    fi
done
