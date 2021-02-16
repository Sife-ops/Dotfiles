#!/bin/sh
# check dependencies

program="$1"
shift

for dep in "$@"; do
    if ! which "$dep" 1>/dev/null 2>&1; then
        if [ -z "$deps" ]; then
            deps="${dep}:"
        else
            deps="${deps}${dep}:"
        fi
    fi
done

if [ -n "$deps" ]; then
    len="$(echo "$deps" | tr -dc ':')"
    len="${#len}"
    for ind in $(seq $len); do
        dep="$(echo "$deps" | cut -d ':' -f "$ind")"
        printf '%s: %s dependency "%s" not installed.\n' \
            "${0##/*/}" \
            "$program" \
            "$dep"
        notify-send \
            --urgency=critical \
            "${0##/*/}" \
            "$program dependency $dep not installed."
    done
    kill 0
fi
