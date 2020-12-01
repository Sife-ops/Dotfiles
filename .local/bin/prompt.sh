#!/bin/sh
# dmenu prompt

msg_help() { echo \
"Usage:
    prompt.sh prompt action"
}

if which checkdeps.sh >/dev/null; then
    if ! checkdeps.sh dmenu; then exit 1; fi fi

[ -z $1 ] && msg_help && exit 1

[ "$(printf "No\\nYes" | dmenu -i -p "$1" -nb darkred -sb red -sf white -nf gray)" = "Yes" ] && $2
