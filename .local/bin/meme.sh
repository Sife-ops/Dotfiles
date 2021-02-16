#!/bin/sh
# select a meme emote

checkdeps.sh dragon-drag-and-drop

. menu.sh

if [ -n "$1" ]; then
   memes="$1"
else
   memes="${MEMES:-${XDG_DATA_HOME:-${HOME}/.local/share}/memes}"
fi

main_list="$(dir_contents "${memes}/")"

choose "$main_list" "memes"
case "$chosen" in
    "") exit 1 ;;
    *) dragon-drag-and-drop -x "${memes}/${chosen}" ;;
esac
#$
