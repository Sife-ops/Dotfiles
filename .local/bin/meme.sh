#!/bin/sh
# select a meme emote

. menu.sh

if which checkdeps.sh 1>/dev/null 2>&1; then
    checkdeps.sh dragon-drag-and-drop || exit 1; fi

if [ -n "$1" ]; then
   MEMES="$1"
elif [ -d "${MEMES:=${XDG_DATA_HOME:-${HOME}/.local/share}/memes}" ]; then
    :
else
    exit 1
fi

main_list(){ #^
    find "${MEMES}/" -type f -print0 |
    xargs --null -n 1 -I {} basename {}
} #$

#^ main menu
chosen=$(menu main_list "meme")
case "$chosen" in
    "") exit 1 ;;
    *) dragon-drag-and-drop -x "${MEMES}/${chosen}" ;;
esac
#$
