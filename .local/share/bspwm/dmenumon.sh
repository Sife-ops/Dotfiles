#!/bin/sh
# bspc monitor menu

if which checkdeps.sh 1>/dev/null 2>&1; then
    checkdeps.sh bspc jq || exit 1; fi

chosen=$(bspc wm -d |
        jq -r \
            '.monitors[] |
            .name, .id' |
        paste - - -d ':' |
        dmenu -b -i -l 20 -p "monitor")

case "$chosen" in
    "") exit 1 ;;
    *) echo "$chosen" | cut -d':' -f2 ;;
esac
