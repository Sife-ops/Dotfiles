#!/bin/bash
# print CPU usage
# todo:
# loop through all cores

cache=/tmp/cpuusecache

icon='💻'

stats=$(head -n 1 /proc/stat |
    awk '{
            printf "%d %d\n", ($2 + $3 + $4 + $5), $5
    }')

last=$(cat "$cache")

total=${stats%% *}
idle=${stats##* }

percent=$(echo "$last" |
    awk '{printf "%d\n", ((100 * ((total - $1) - (idle - $2))) / (total - $1))}' \
    2>/dev/null \
    total="$total" idle="$idle")

printf '%s%s%%' "$icon" "$percent"

echo "$stats" > "$cache"
