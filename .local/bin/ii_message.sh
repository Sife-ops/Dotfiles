#!/bin/sh

message=$(mktemp /tmp/$(basename $PWD)_ii_XXX)

while true; do
    truncate -s 0 "$message"
    ${EDITOR:-vim} "$message"
    chars=$(wc -m "$message" | cut -d ' ' -f 1)
    if [ "$chars" = "0" ]; then
        exit
    else
        cat "$message" > "./in"
    fi
done
