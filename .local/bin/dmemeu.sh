#!/bin/sh
# select a meme emote

if which checkdeps.sh 1>/dev/null 2>&1; then
    checkdeps.sh dragon-drag-and-drop dmenu || exit 1; fi

msg_help() { echo \
"Usage:
    dmemeyou.sh DIR"
}

[ -z "$1" ] && msg_help && exit 1

emote_dir=$1
chosen=$(find "$emote_dir" -type f -0 |
    xargs -n 1 -I {} basename {} |
    dmenu -b -i -l 30)

case "$chosen" in
    "") exit 1 ;;
    *) dragon-drag-and-drop -x "$emote_dir"/"$chosen" ;;
esac
