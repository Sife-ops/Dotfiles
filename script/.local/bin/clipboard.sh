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

action_list () {
    main_list
    echo "============================================================================================================================================================================================================================================================================================================================="
    echo "edit"
    echo "open url"
}

src=$(main_list | dmenu ${DMENU_OPTS} -i -l 20); [ "$src" = "" ] && exit 1
src=$(echo "$src" | cut -d ':' -f 1)
case "$src" in
    clipboard) content=$(xclip -o -selection clipboard) ;;
    primary) content=$(xclip -o -selection primary) ;;
    secondary) content=$(xclip -o -selection secondary) ;;
    tmux) content=$(tmux show-buffer) ;;
    *) content=$(cat ${CLIPBOARD}/${src}) ;;
esac

trg=$(action_list | dmenu ${DMENU_OPTS} -i -l 20); [ "$trg" = "" ] && exit 1
trg=$(echo "$trg" | cut -d ':' -f 1)
case "$trg" in
    clipboard) echo "$content" | xclip -i -selection clipboard ;;
    primary) echo "$content" | xclip -i -selection primary ;;
    secondary) echo "$content" | xclip -i -selection secondary ;;
    tmux) tmux set-buffer "$content" ;;
    edit) tmp=$(mktemp /tmp/clipboard_XXX)
        echo "$content" > "$tmp"
        ${TERMEXEC:-xterm -e} ${EDITOR:-vim} "$tmp"
        case "$src" in
            clipboard) cat "$tmp" | xclip -i -selection clipboard ;;
            primary) cat "$tmp" | xclip -i -selection primary ;;
            secondary) cat "$tmp" | xclip -i -selection secondary ;;
            tmux) tmux set-buffer "$(cat "$tmp")" ;;
            *) cat "$tmp" > "${CLIPBOARD}/${src}" ;;
        esac
        rm "$tmp" ;;
    "open url")
        case "$src" in
            clipboard) url.sh "$(xclip -o -selection clipboard)" ;;
            primary) url.sh "$(xclip -o -selection primary)" ;;
            secondary) url.sh "$(xclip -o -selection secondary)" ;;
            tmux) url.sh "$(tmux show-buffer)" ;;
            *) url "$(cat "${CLIPBOARD}/${src}")" ;;
        esac ;;
    *) echo "$content" > "${CLIPBOARD}/${trg}" ;;
esac
