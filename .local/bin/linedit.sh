#!/bin/sh
# graphical line editor

. menu.sh

# cat "$1"

if [ -n "$1" ]; then
    file="$1"
else
    exit 1
fi

list(){ #^
    cat "$file" | awk '{ print NR " " $0 }'
} #$

while true; do
    chosen=$(menu list)
    case "$chosen" in
        "") exit 1 ;;
        *) : ;;
    esac

    ln=$(echo "$chosen" | cut -d ' ' -f 1)
    l=$(echo "$chosen" | cut -d ' ' -f 1 --complement)

    input=$(menu list "$chosen" t)
    case "$chosen" in
        "") exit 1 ;;
        *) : ;;
    esac

    sed -i "${ln}${input}" "$file"
done
