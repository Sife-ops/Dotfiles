#!/bin/sh
# bookmark selector

. menu.sh

bookmarks="${BOOKMARKS:-${XDG_DATA_HOME:-${HOME}/.local/share}/bookmarks}"

main_list="$(grep -v '^#' "$bookmarks" | sed '/^$/d' | sort)
Edit ..."

choose "$main_list" "bookmarks"
url=$(echo "$chosen" | cut -d '|' -f 2 | tr -d "[:space:]")
case "$chosen" in
    "Edit ...") buffer "$bookmarks" ;;
    "") exit 1 ;;
    *) url.sh $url ;;
esac


