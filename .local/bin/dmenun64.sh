#!/bin/sh
# play an N64 game

. menu.sh

if which checkdeps.sh 1>/dev/null 2>&1; then
    checkdeps.sh mupen64plus || exit 1; fi

if [ -n "$1" ]; then
   N64ROMS="$1"
elif [ -d "${N64ROMS:=${XDG_DATA_DIR:-${HOME}/.local/share}/roms/n64}" ]; then
    :
else
    exit 1
fi

main_list(){ #^
    find "${N64ROMS}/" -type f -print0 |
    xargs --null -n 1 -I {} basename {}
} #$

#^ main menu
chosen=$(menu main_list "N64")
case "$chosen" in
    "") exit 1 ;;
    *) mupen64plus "${N64ROMS}/${chosen}" ;;
esac
#$
