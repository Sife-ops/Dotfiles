#!/bin/sh
# dmenu bookmark selector

if which checkdeps.sh >/dev/null 2>&1; then
    checkdeps.sh dmenu || exit 1; fi

bookmarksFile="${BOOKMARKS:-${XDG_DATA_HOME}/bookmarks}"
chosen=$(cat "$bookmarksFile" |
    grep -v '#' |
    sed '/^$/d' |
    sort |
    dmenu -b -i -l 20 -p "bookmarks" |
    cut -d'|' -f2 |
    tr -d "[:space:]")

$BROWSER "$chosen"
