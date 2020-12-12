#!/bin/sh
# show keycodes of keys interactively

if which checkdeps.sh >/dev/null 2>&1; then
    checkdeps.sh xev || exit 1; fi

xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'
