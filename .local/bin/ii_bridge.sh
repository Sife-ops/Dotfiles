#!/bin/sh
# usage: ii_bridge.sh FROM_OUT TO_IN [IGNORE]

from="$1"
to="$2"
ignore="${3:+"<${3}>"}"

tail -F -n 1 "$from" | while read a b c; do
    case "$b" in
        "$ignore") : ;;
        "-!-") : ;;
        *) echo "$c" > "$to" ;;
    esac
done
