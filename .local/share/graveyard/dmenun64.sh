#!/bin/sh
# play an N64 game

. menu.sh

if [ -n "$1" ]; then
   n64roms="$1"
else
   n64roms="${N64ROMS:-${XDG_DATA_DIR:-${HOME}/.local/share}/roms/n64}"
fi

main_list="$(dir_contents "${n64roms}/")"

choose "$main_list" "N64"
case "$chosen" in
    "") exit 1 ;;
    *) mupen64plus "${n64roms}/${chosen}" ;;
esac
