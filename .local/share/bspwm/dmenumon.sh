#!/bin/sh
# bspc monitor menu

checkdeps.sh bspc jq

dmenucmd="${DMENU_CMD:-dmenu -b -i -l 20}"
alias dmenucmd="$dmenucmd"

chosen=$(bspc wm -d |
    jq -r \
        '.monitors[] |
        .name, .id' |
    paste - - -d ':' |
    dmenucmd -p "monitor")

case "$chosen" in
    "") kill 0 ;;
    *) echo "$chosen" | cut -d':' -f2 ;;
esac
