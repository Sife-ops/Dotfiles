#!/bin/sh
# select a meme emote

. menu.sh

if which checkdeps.sh 1>/dev/null 2>&1; then
    checkdeps.sh dragon-drag-and-drop || exit 1; fi

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
