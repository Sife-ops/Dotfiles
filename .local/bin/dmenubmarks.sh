#!/bin/sh
# dmenu bookmark selector

if which checkdeps.sh 1>/dev/null 2>&1; then
    checkdeps.sh dmenu || exit 1; fi

bookmarks="${BOOKMARKS:-${XDG_DATA_HOME}/bookmarks}"
chosen=$( grep -v '^#' "$bookmarks" |
    sed '/^$/d' |
    sort |
    dmenu -b -i -l 20 -p "bookmarks" |
    cut -d'|' -f2 |
    tr -d "[:space:]")

case "$chosen" in
    "") exit 1 ;;
    *) $BROWSER "$chosen" ;;
esac


