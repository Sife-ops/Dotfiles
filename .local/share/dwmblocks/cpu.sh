#!/bin/sh
# print CPU usage

cpu="$(top -b -n1 | sed -un 3p | awk '{ print $2 }')%"
#cpu="$(ps -A -o pcpu | tail -n+2 | paste -sd+ | bc)%"
icon="🖥"
printf "%s%s\\n" "$icon" "$cpu"
