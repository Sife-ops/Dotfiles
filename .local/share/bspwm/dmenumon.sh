#!/bin/sh
# bspc monitor menu

checkdeps.sh bspc jq

dmenucmd="${DMENU_CMD:-dmenu -b -i -l 20}"
alias dmenucmd="$dmenucmd"

bspc wm -d |
    jq -r '.monitors[] | .name, .id' |
    paste - - -d ':' |
    dmenucmd -p "monitor" |
    cut -d':' -f2
