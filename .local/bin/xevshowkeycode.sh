#!/bin/sh
# show keycodes of keys interactively

if which checkdeps.sh >/dev/null; then
    if ! checkdeps.sh xev; then exit 1; fi fi

xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'
