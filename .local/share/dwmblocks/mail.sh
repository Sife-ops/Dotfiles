#!/bin/sh
# print unread feeds

unread=$(tac "$NOTIFICATIONS" 2>/dev/null |
    grep 'New Email' 2>/dev/null |
    head -n1 |
    jq -r '.body' |
    sed -r 's/.* ([0-9]+)( unread).*/\1/')    # need POSIX rewrite
# icon="✉️"
icon="📧"

if test "$unread" -eq "$unread" 1>/dev/null 2>&1; then   # evil hack
    if [ "$unread" -lt "1" ]; then
        printf " "
    else
        printf "%s%s" "$icon" "$unread"
    fi
else
    printf ""
    exit 0
fi

