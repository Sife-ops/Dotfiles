#!/bin/sh
# fzf bookmark selector

if which checkdeps.sh >/dev/null 2>&1; then
    checkdeps.sh fzf || exit 1; fi

msg_help() { echo \
"Usage:
    fmarks.sh file"
}

[ -z $1 ] && msg_help && exit 1

while true; do
    bm=$(cat $1 \
        | grep -v '#' \
        | sed '/^$/d' \
        | sort \
        | fzf \
        | awk -F'|' '{ print $2 }' \
        | tr -d "[:space:]")
    xdg-open "$bm"
done
