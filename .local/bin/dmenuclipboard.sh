#!/bin/sh
# manage clipboards

#^ setup
if which checkdeps.sh 1>/dev/null 2>&1; then
    checkdeps.sh xclip dmenu || exit 1; fi

alias dmenucmd='dmenu -b -i -l 20'

user_clipboard="${CLIPBOARD:-${HOME}/.local/share/clipboard}"
user_clipboard_dir="${CLIPBOARD_DIR:-${HOME}/.local/share/clipboard.d}"
#$

#^ functions
menu_a () {
    echo "clipboard: $(xclip -o -selection clipboard 2>/dev/null | head -n1)"
    echo "primary: $(xclip -o -selection primary 2>/dev/null | head -n1)"
    echo "secondary: $(xclip -o -selection secondary 2>/dev/null | head -n1)"

    if [ -f "$user_clipboard" ]; then
        echo "user: $(head -n1 "$user_clipboard")"
    fi

    if [ -d "$user_clipboard_dir" ]; then
        for file in $(find "$user_clipboard_dir" -type f); do # failing shellcheck
            base=$(basename "$file")
            echo "user/${base}: $(head -n1 "${file}")"
        done | sort
    fi
}

menu_b () {
    # menu_b $chosen_a
    if [ -d "$user_clipboard_dir" ]; then
        echo "$1" | grep '^user\/.*' && \
        printf "delete user clipboard: %s\n" "$1"
        printf "new user clipboard: ...\n"
    fi
} #$

#^ main menu
chosen=$(menu_a |
    dmenucmd -p "source" |
    cut -d':' -f1)

case "$chosen" in
    primary|secondary|clipboard) cmd_a="xclip -o -selection $chosen" ;;
    user/*) cmd_a="cat ${user_clipboard_dir}/$(basename "$chosen")" ;;
    user) cmd_a="cat $user_clipboard" ;;
    "") exit 1 ;;
esac #$

#^ second menu
chosen=$( (menu_a;
           menu_b "$chosen";) |
    dmenucmd -p "target" |
    cut -d':' -f1)

case "$chosen" in
    primary|secondary|clipboard) cmd_b="| xclip -i -selection $chosen" ;;
    user/*) cmd_b="> ${user_clipboard_dir}/$(basename "$chosen")" ;;
    user) cmd_b="> $user_clipboard" ;;
    "new user clipboard")
        cmd_b="> ${user_clipboard_dir}/$(printf "" | dmenu -b -p "name")" ;;
    "delete user clipboard")
        rm "${user_clipboard_dir}/$(basename "$chosen")"
        exit 0 ;;
    "") exit 1;;
esac #$

eval "$cmd_a $cmd_b"
# echo "$cmd_a $cmd_b" # debug

# vim: fdm=marker fmr=#^,#$
