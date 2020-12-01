#!/bin/sh
# select a meme emote

msg_help() { echo \
"Usage:
    dmemeyou.sh DIR"
}

if which checkdeps.sh >/dev/null; then
    if ! checkdeps.sh dragon-drag-and-drop dmenu; then exit 1; fi fi

[ -z $1 ] && msg_help && exit 1

emotedir=$1
chosen="$(ls "$emotedir" | dmenu -i -l 30)"

[ -z "$chosen" ] && exit

dragon-drag-and-drop -x "$emotedir"/"$chosen"
