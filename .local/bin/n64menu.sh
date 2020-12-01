#!/bin/sh
# play an N64 game

msg_help() { echo \
"Usage:
    n54.sh ROMS_DIR"
}

if which checkdeps.sh 1>/dev/null 2>&1; then
    if ! checkdeps.sh dmenu mupen64plus; then exit 1; fi fi

[ -z $1 ] && msg_help && exit 1

romdir=$1
rom="$(ls "$romdir" | dmenu -b -i -l 40 -p "ROM")"
mupen64plus "$romdir"/"$rom"
