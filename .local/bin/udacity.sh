#!/bin/sh

file="/tmp/udacity/file"
mkdir -p "$(dirname "$file")"

if [ -n "$2" ]; then

    if [ "$2" = "cpp" ]; then
        ft="cpp"
        cs="//"

    elif [ "$2" = "sh" ]; then
        ft="sh"
        cs="#"

    fi

fi

sleep 0.5

if [ "$1" = "yank" ]; then

    xdotool key Control_L+a
    xdotool key Control_L+c

    xclip -o -selection clipboard > "$file"
    printf '\n\n%s vim: ft=%s' "$cs" "$ft" >> "$file"
    ${TERMEXEC:-xterm -e} nvim "$file"

elif [ "$1" = "put" ]; then

    sed -i '/vim: ft=/d' "$file"
    cat "$file" | xclip -i -selection clipboard

    xdotool key Control_L+a
    xdotool key BackSpace
    xdotool key Control_L+v

else

    exit 1

fi
