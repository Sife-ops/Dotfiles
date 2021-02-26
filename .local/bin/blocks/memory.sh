#!/bin/sh
# print memory usage

mem=$(free -h | grep 'Mem:' | awk '{ print $7 }')
icon="🧠"
printf "%s%s\\n" "$icon" "$mem"
