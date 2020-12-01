#!/bin/sh
# kill program if running, else start program

msg_help() { echo \
"Usage:
    tog.sh program"
}

[ -z $1 ] && msg_help && exit 1

prog=$(pgrep "$1")
if [ -z "$prog" ]; then
    "$@"
else
    kill -9 "$prog"
fi
