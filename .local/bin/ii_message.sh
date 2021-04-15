#!/bin/sh

message=$(mktemp /tmp/ii_message_$(basename $PWD)_XXX)

while true; do
    truncate -s 0 "$message"
    ${EDITOR:-vim} "$message"
    chars=$(wc -m "$message" | cut -d ' ' -f 1)
    if [ "$chars" = "0" ]; then
        rm "$message"
        exit
    else
        cat "$message" > "./in"
        # mpv "${SFX}/AOL/send.flac" 1>/dev/null 2>&1 &
    fi
done
