#!/bin/sh
# play an N64 game

if which checkdeps.sh 1>/dev/null 2>&1; then
    checkdeps.sh dmenu mupen64plus || exit 1; fi

msg_help() { echo \
"Usage:
    n54.sh ROMS_DIR"
}

[ -z "$1" ] && msg_help && exit 1

romdir=$1
rom="$(ls "$romdir" | dmenu -b -i -l 40 -p "ROM")" # change to find
mupen64plus "$romdir"/"$rom"
