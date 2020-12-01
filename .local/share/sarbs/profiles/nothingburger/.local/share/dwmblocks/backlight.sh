#!/bin/sh
# print brightness level

brmaxdev="/sys/class/backlight/intel_backlight/max_brightness"
brmax="$(cat $brmaxdev)"
brdev="/sys/class/backlight/intel_backlight/brightness"
brnum="$(($(cat $brdev) * 100))"
pbr="$(($brnum / $brmax))%"

icon="☀"
printf "%s%s\\n" "$icon" "$pbr"
