#!/bin/sh

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
