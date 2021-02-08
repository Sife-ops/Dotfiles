#!/bin/sh
# print brightness level

brmaxdev="/sys/class/backlight/intel_backlight/max_brightness"
brdev="/sys/class/backlight/intel_backlight/brightness"
[ -f "$brmaxdev" ] || exit 1
[ -f "$brdev" ] || exit 1

brmax="$(cat $brmaxdev)"
br="$(($(cat $brdev) * 100))"
brperc="$(($br / $brmax))%"

icon="☀"
printf "%s%s\\n" "$icon" "$brperc"
