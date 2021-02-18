#!/bin/sh
# print last notification

notifications="${NOTIFICATIONS:-${XDG_DATA_HOME:-${HOME}/.local/share}/notifications}"
charlim=20

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

echo "$icon $summary | $body"
