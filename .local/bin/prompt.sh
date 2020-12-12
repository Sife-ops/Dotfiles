#!/bin/sh
# dmenu prompt

if which checkdeps.sh >/dev/null 2>&1; then
    checkdeps.sh dmenu || exit 1; fi

msg_help() { echo \
"Usage:
    prompt.sh prompt action"
}

[ -z $1 ] && msg_help && exit 1

[ "$(printf "No\\nYes" | dmenu -i -p "$1" -nb darkred -sb red -sf white -nf gray)" = "Yes" ] && $2
