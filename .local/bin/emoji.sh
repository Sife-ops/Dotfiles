#!/bin/sh
# copy emoji to clipboard

. menu.sh

if [ -n "$1" ]; then
   emoji="$1"
else
   emoji="${EMOJI:-${XDG_DATA_HOME:-${HOME}/.local/share}/emoji}"
fi

main_list="$(cat "$emoji")"

choose "$main_list" "emoji"
emoji="$(echo "$chosen" | sed "s/ .*//")"
case "$chosen" in
    "") exit 1 ;;
    *) clipboard yank "$emoji"
        if [ -z "$nox" ]; then
            sleep 0.25
            xdotool type --clearmodifiers "$emoji"
        fi ;;
esac
