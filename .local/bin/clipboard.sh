#!/bin/sh
# manage clipboards
# todo:
# implement new/delete clipboard
# "clear all"

. menu.sh

[ -d "${CLIPBOARD_DIR:=${XDG_DATA_HOME:-${HOME}/.local/share}/clipboard.d}" ] || \
    nouserclipd=t

#^ lists
main_list () { #^
    [ -z "$noxclip" ] && \
        echo "clipboard: $(xclip -o -selection clipboard 2>/dev/null | head -n1)"
    [ -z "$noxclip" ] && \
        echo "primary: $(xclip -o -selection primary 2>/dev/null | head -n1)"
    [ -z "$noxclip" ] && \
        echo "secondary: $(xclip -o -selection secondary 2>/dev/null | head -n1)"

    [ -z "$nouserclip" ] && echo "user: $(head -n1 "$CLIPBOARD")"

    if [ -z "$nouserclipd" ]; then
        for file in $(find "${CLIPBOARD_DIR}/" -type f); do # failing shellcheck
            base=$(basename "$file")
            echo "user/${base}: $(head -n1 "${file}")"
        done | sort
    fi
} #$
#$

#^ main menu
chosen=$(menu main_list | cut -d':' -f1)
case "$chosen" in
    primary|secondary|clipboard) cmd_a="xclip -o -selection $chosen" ;;
    user/*) cmd_a="cat ${CLIPBOARD_DIR}/$(basename "$chosen")" ;;
    user) cmd_a="cat $CLIPBOARD" ;;
    "") exit 1 ;;
    *) exit 1 ;;
esac #$

#^ second menu
chosen=$(menu main_list | cut -d ':' -f 1)
case "$chosen" in
    primary|secondary|clipboard) cmd_b="| xclip -i -selection $chosen" ;;
    user/*) cmd_b="> ${CLIPBOARD_DIR}/$(basename "$chosen")" ;;
    user) cmd_b="> $CLIPBOARD" ;;
    # "new user clipboard") : ;;
    # "delete user clipboard") : ;;
    "") exit 1 ;;
    *) exit 1 ;;
esac #$

[ -n "$nonotify" ] || notify-send "sfx" "win95/DA_MENUC.WAV"
eval "$cmd_a $cmd_b"

# vim: fdm=marker fmr=#^,#$
