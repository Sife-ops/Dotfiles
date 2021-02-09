#!/bin/sh
# print last notification

notifications="${NOTIFICATIONS:-${XDG_DATA_HOME:-${HOME}/.local/share}/notifications}"
charlim=25

json=$(tail -n 1 "$notifications")

urgency=$(echo "$json" | jq -r '.urgency')
case "$urgency" in
    LOW) icon=😁 ;;
    NORMAL) icon=💬 ;;
    CRITICAL) icon=⚠️  ;;
esac

appname=$(echo "$json" | jq -r '.appname' | sed "s/\(^.\{$charlim\}\)\(.*\)/\1 \.\.\./")
summary=$(echo "$json" | jq -r '.summary' | sed "s/\(^.\{$charlim\}\)\(.*\)/\1 \.\.\./")
body=$(echo "$json" | jq -r '.body' | sed "s/\(^.\{$charlim\}\)\(.*\)/\1 \.\.\./")

echo "$icon $appname | $summary | $body $icon"

# shorten(){
#     echo "$2" |
#         cut -d '|' -f "$1" |
#         sed "s/\(^.\{$charlim\}\)\(.*\)/\1 \.\.\./"
# }

# notif=$(tail -n1 "$notifications")
# appname="$(shorten 1 "$notif")"
# summary="$(shorten 2 "$notif")"
# body="$(shorten 3 "$notif")"
# notif="${appname}|${summary}|${body}"

# echo "$notif"
