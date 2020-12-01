#!/bin/sh
# fzf bookmark selector

msg_help() { echo \
"Usage:
    fmarks.sh file"
}

if which checkdeps.sh >/dev/null; then
    if ! checkdeps.sh fzf; then exit 1; fi fi

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
