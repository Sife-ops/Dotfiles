#!/bin/sh
# print CPU temperature (for Ryzen 7)

temp=$(sensors 2>/dev/null \
    | grep 'k10temp' -A2 \
    | grep 'temp1' \
    | awk '{ print $2 }')
# printf "%s\\n" "$temp"
icon="🌡"
printf "%s%s\\n" "$icon" "$temp"
