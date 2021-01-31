#!/bin/sh
# bookmark selector

. menu.sh

[ -f "${BOOKMARKS:=${XDG_DATA_HOME:-${HOME}/.local/share}/bookmarks}" ] || \
    exit 1

main_list(){
    grep -v '^#' "$BOOKMARKS" |
    sed '/^$/d' |
    sort
}

chosen=$(menu main_list "bookmarks" |
    cut -d '|' -f 2 |
    tr -d "[:space:]")

case "$chosen" in
    "") exit 1 ;;
    *) $BROWSER "$chosen" ;;
esac


