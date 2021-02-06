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
    xdotool key Page_Up
    xdotool key Home
    xdotool keydown Shift_L
    xdotool key --repeat 10 Page_Down
    xdotool key End
    xdotool keyup Shift_L

    xclip -o -selection primary > "$file"
    printf '\n\n%s vim: ft=%s' "$cs" "$ft" >> "$file"
    st -e nvim "$file"

elif [ "$1" = "put" ]; then
    sed -i '/vim: ft=/d' "$file"
    cat "$file" | xclip -i -selection clipboard

    xdotool key Page_Up
    xdotool key Home
    xdotool keydown Shift_L
    xdotool key --repeat 10 Page_Down
    xdotool key End
    xdotool keyup Shift_L
    xdotool key Control_L+v

else
    exit 1

fi

# if [ "$1" = "c" ]; then
#     cat "$fdsa" | xclip -i -selection clipboard
#     xdotool key Page_Up
#     xdotool key Home
#     xdotool keydown Shift_L
#     xdotool key --repeat 3 Page_Down
#     xdotool key End
#     xdotool keyup Shift_L
#     xdotool key Control_L+v
# fi
