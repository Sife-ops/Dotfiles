#!/bin/sh
# print unread feeds

statusbar="${STATUSBAR:-${XDG_DATA_HOME:-${HOME}/.local/share}/statusbar}"

icon="📰"
unread=$(grep 'feeds' "$statusbar" | tail -n1 | cut -d ':' -f 2)

if test "$unread" -eq "$unread" 1>/dev/null 2>&1; then   # evil hack
    if [ "$unread" -lt "1" ]; then
        printf ""
    else
        printf "%s%s" "$icon" "$unread"
    fi
else
    printf ""
fi
