#!/bin/sh
# print unread feeds

notifications="${NOTIFICATIONS:-${XDG_DATA_HOME:-${HOME}/.local/share}/notifications}"

icon="📰"
unread=$(grep 'newsboat' "$notifications" |
    tail -n1 |
    jq -r '.summary' |
    sed -r 's/.*\(([0-9]+)( unread articles).*/\1/')    # POSIX rewrite

if test "$unread" -eq "$unread" 1>/dev/null 2>&1; then   # evil hack
    if [ "$unread" -lt "1" ]; then
        printf ""
    else
        printf "%s%s" "$icon" "$unread"
    fi
else
    printf ""
fi
