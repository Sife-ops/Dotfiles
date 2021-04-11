#!/bin/sh
# clipboard manager

main_list () {
    echo "clipboard: $(xclip -o -selection clipboard | head -n1)"
    echo "primary: $(xclip -o -selection primary | head -n1)"
    echo "secondary: $(xclip -o -selection secondary | head -n1)"
    echo "tmux: $(tmux show-buffer | head -n1)"
    for file in $(find ${CLIPBOARD}/ -type f); do
        echo "$(basename "$file"): $(head -n1 "$file")"
    done | sort
}

a=$(main_list | ${DMENU_CMD:-dmenu})
a=$(echo "$a" | cut -d ':' -f 1)
case "$a" in
    clipboard) a=$(xclip -o -selection clipboard) ;;
    primary) a=$(xclip -o -selection primary) ;;
    secondary) a=$(xclip -o -selection secondary) ;;
    tmux) a=$(tmux show-buffer) ;;
    "") exit 1 ;;
    *) a=$(cat ${CLIPBOARD}/${a}) ;;
esac

b=$(main_list | ${DMENU_CMD:-dmenu})
b=$(echo "$b" | cut -d ':' -f 1)
case "$b" in
    clipboard) echo "$a" | xclip -i -selection clipboard ;;
    primary) echo "$a" | xclip -i -selection primary ;;
    secondary) echo "$a" | xclip -i -selection secondary ;;
    tmux) tmux set-buffer "$a" ;;
    "") exit 1 ;;
    *) echo "$a" > "${CLIPBOARD}/${b}" ;;
esac
