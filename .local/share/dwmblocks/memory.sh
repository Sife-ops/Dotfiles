#!/bin/sh
# print memory usage

mem=$(free -h | sed -un 2p | awk '{ print $4 }')
icon="🧠"
printf "%s%s\\n" "$icon" "$mem"
