#!/bin/sh

color1="\033[1;37m"
color2="\033[1;32m"
color3="\033[0;33m"

tail -F -n 100 "$1" | while read a b c; do
    printf "%b%s %b%s %b%s\n" \
        "$color1" $(date --date="@${a}" | cut -d ' ' -f 4) \
        "$color2" "$b" \
        "$color3" "$c"
done
