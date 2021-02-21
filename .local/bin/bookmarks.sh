#!/bin/sh
# bookmark selector

. menu.sh

config="${XDG_CONFIG_HOME:-${HOME}/.config}/bookmarks/config"
while IFS= read -r line; do
    case "$line" in
        '#'*) : ;;
        *) eval "$line" ;;
    esac
done < "$config"

[ ! -f "$BOOKMARKS" ] && curl "$BOOKMARKS_GIST" > "$BOOKMARKS"
gist="$(echo "$BOOKMARKS_GIST" | cut -d '/' -f 5)"
gist="https://gist.github.com/$gist"

main_list="$(grep -v '^#' "$BOOKMARKS" | sed '/^$/d' | sort)
Edit ...
Sync ..."

choose "$main_list" "bookmarks"
url=$(echo "$chosen" | cut -d '|' -f 2 | tr -d "[:space:]")
case "$chosen" in
    "Edit ...")
        gh auth login --with-token "$(gpg --decrypt "$BOOKMARKS_TOKEN")"
        if [ -n "$nox" ]; then
            gh gist edit "$gist"; else
            ${TERMEXEC:-xterm -e} gh gist edit "$gist"; fi
        curl "$BOOKMARKS_GIST" > "$BOOKMARKS" ;;
    "Sync ...") curl "$BOOKMARKS_GIST" > "$BOOKMARKS" ;;
    "") exit 1 ;;
    *) url.sh $url ;;
esac
