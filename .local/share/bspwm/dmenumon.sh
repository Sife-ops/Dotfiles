#!/bin/sh
# bspc monitor menu

if which checkdeps.sh 1>/dev/null 2>&1; then
    checkdeps.sh bspc jq || exit 1; fi

DMENU_CMD="${DMENU_CMD:-dmenu -b -i -l 20}"
alias dmenucmd="$DMENU_CMD"

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
