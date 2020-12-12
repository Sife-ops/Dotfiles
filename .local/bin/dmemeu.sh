#!/bin/sh
# select a meme emote

if which checkdeps.sh >/dev/null 2>&1; then
    checkdeps.sh dragon-drag-and-drop dmenu || exit 1; fi

msg_help() { echo \
"Usage:
    dmemeyou.sh DIR"
}

[ -z $1 ] && msg_help && exit 1

emotedir=$1
chosen="$(ls "$emotedir" | dmenu -i -l 30)"

[ -z "$chosen" ] && exit

dragon-drag-and-drop -x "$emotedir"/"$chosen"
