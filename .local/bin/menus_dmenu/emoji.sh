#!/bin/sh
# https://unicode.org/Public/emoji/13.1/emoji-sequences.txt

url="https://unicode.org/Public/emoji/13.1/emoji-sequences.txt"
base=$(basename "$url")

db="${XDG_CACHE_HOME}/${base}"

[ -f "$db" ] || curl -L "$url" -o "$db"
[ -f "$db" ] || exit 1

chosen=$(while IFS=';' read a b c; do
            case "$a" in
                '#'*|'') : ;;
                *) echo "$c" ;;
            esac
        done < "$db" |
            ${DMENU_CMD:-dmenu} |
            sed -E 's/(.*\()(.)(.*)/\2/')

echo "$chosen" | xclip -i -selection clipboard
sleep 0.25
xdotool type --clearmodifiers "$chosen"
