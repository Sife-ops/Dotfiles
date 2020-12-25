#!/bin/sh
# print last notification

tail -n1 $NOTIFICATIONS |
    jq -r '.app_name, .summary, .body' 2>/dev/null |
    sed "1,2s/$/ \|/" |
    paste -s -d' '
