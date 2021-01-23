#!/bin/sh
# bspc monitor menu

if which checkdeps.sh >/dev/null 2>&1; then
    checkdeps.sh bspc jq || exit 1; fi

chosen=$(\
    bspc wm -d |
        jq '.monitors[] |
            .name, .id' |
        tr -d '"' |
        paste - - -d ':' |
        dmenu -b -i -l 20 -p "monitor")

case $chosen in
    "") exit ;;
    *) echo $chosen | cut -d':' -f2 ;;
esac
