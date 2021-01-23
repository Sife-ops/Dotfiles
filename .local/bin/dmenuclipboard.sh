#!/bin/bash
# manage clipboards

#^ preamble
if which checkdeps.sh >/dev/null 2>&1; then
    checkdeps.sh xclip dmenu || exit 1; fi

shopt -s expand_aliases
alias dmenucmd='dmenu -b -i -l 20'

user_clipboard="${CLIPBOARD:-${HOME}/.local/share/clipboard}"
user_clipboard_dir="${CLIPBOARD_DIR:-${HOME}/.local/share/clipboard.d}"
#$

#^ functions
function menu_a () {
    # echo "~# Xorg #~"
    echo "clipboard: $(xclip -o -selection clipboard 2>/dev/null | head -n1)"
    echo "primary: $(xclip -o -selection primary 2>/dev/null | head -n1)"
    echo "secondary: $(xclip -o -selection secondary 2>/dev/null | head -n1)"

    if [ -f "$user_clipboard" ]; then
        # echo "~# User #~"
        echo "user: $(head -n1 $user_clipboard)"
    fi

    if [ -d "$user_clipboard_dir" ]; then
        # [ -f "$user_clipboard" ] || echo "~# User #~"
        for file in $(find $user_clipboard_dir -type f -exec basename {} \;); do
            echo "user/${file}: $(head -n1 ${user_clipboard_dir}/${file})"
        done | sort
    fi
}

function menu_b () {
    # menu_b $chosen_a
    if [ -d "$user_clipboard_dir" ]; then
        echo "$1" | grep '^user\/.*' && \
        echo "delete user clipboard: $1"
        echo "new user clipboard: ..."
    fi
} #$

#^ dmenu
chosen_a=$(menu_a |
    dmenucmd -p "source" |
    cut -d':' -f1)
[ -z "$chosen_a" ] && exit 1

chosen_b=$(cat <(menu_a) <(menu_b "$chosen_a") |
    dmenucmd -p "target" |
    cut -d':' -f1)
[ -z "$chosen_b" ] && exit 1
#$

#^ xclip
case $chosen_a in
    primary|secondary|clipboard) cmd_a="xclip -o -selection $chosen_a" ;;
    user/*) cmd_a="cat ${user_clipboard_dir}/$(basename $chosen_a)" ;;
    user) cmd_a="cat $user_clipboard" ;;
esac

case $chosen_b in
    primary|secondary|clipboard) cmd_b="| xclip -i -selection $chosen_b" ;;
    user/*) cmd_b="> ${user_clipboard_dir}/$(basename $chosen_b)" ;;
    user) cmd_b="> $user_clipboard" ;;
    "new user clipboard")
        cmd_b="> ${user_clipboard_dir}/$(printf "" | dmenu -b -p "name")" ;;
    "delete user clipboard")
        rm "${user_clipboard_dir}/$(basename $chosen_a)"
        exit 0 ;;
esac
#$

eval "$cmd_a $cmd_b"
# echo "$cmd_a $cmd_b" # debug

# vim: fdm=marker fmr=#^,#$
