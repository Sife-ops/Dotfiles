#!/bin/sh

message="$(mktemp /tmp/ii_message_$(basename $PWD)_XXX)"

while true; do
    truncate -s 0 "$message"
    "${EDITOR:-vim}" "$message"
    chars=$(wc -m "$message" | cut -d ' ' -f 1)
    if [ "$chars" = "0" ]; then
        rm "$message"
        exit
    else
        if [ -e "./in" ]; then
            cat "$message" > "./in"
        else
            printf "/j %s %s\n" \
                "$(basename "$PWD")" \
                "$(cat "$message")" > "../in"
        fi
    fi
done
