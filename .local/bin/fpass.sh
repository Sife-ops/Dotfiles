#!/bin/bash
# fzf wrapper for bitwarden-cli

if which checkdeps.sh >/dev/null 2>&1; then
    checkdeps.sh bw fzf jq xclip || exit 1; fi

sessionkey=$(bw unlock \
    | grep 'export' \
    | sed 's/\(^.*BW_SESSION="\)\(.*\)\("\)/\2/')

while true; do
bw get item --session "$sessionkey" "$(\
	bw list items --session "$sessionkey" \
	| jq '.[] | "\(.name) | username: \(.login.username) | id: \(.id)" ' \
	| fzf \
	| awk '{print $(NF -0)}' \
	| sed 's/\"//g')" \
    | jq '.login.password' \
    | sed 's/\"//g' \
    | tr -d '\n' \
    | xclip -sel clip
done
