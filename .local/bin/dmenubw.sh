#!/bin/bash
# dmenu interface for bitwarden-cli

shopt -s expand_aliases
alias bw_cmd="bw --nointeraction"
alias dmenu_cmd="${DMENUCMD:-dmenu -b -i -l 20}"
alias prompt_cmd="zenity --password"
# alias prompt_cmd='yad --entry --entry-label="Password: " --hide-text'

password_cache="${BW_GPG_FILE:-$HOME/.cache/bw.gpg}"

if which checkdeps.sh >/dev/null 2>&1; then
    checkdeps.sh dmenu bw gpg jq xclip ${prompt_cmd%% *} || exit 1; fi

if [ ! -f "$password_cache" ]; then
    sessionkey=$(bw_cmd unlock "$(prompt_cmd)" |
        grep 'export' |
        sed 's/^.*BW_SESSION="\(.*\)"/\1/')
    if bw_cmd list items --session "$sessionkey" >/dev/null; then
        echo "$sessionkey" |
            gpg --quiet --recipient "$BW_GPG_NAME" \
                --encrypt --output "$password_cache"
    else
        exit 1
    fi
else
    sessionkey=$(gpg --quiet --decrypt "$password_cache")
fi

# jq -r '.[] | "\(.name) | username: \(.login.username) | id: \(.id)"' |
id=$(bw_cmd list items --session "$sessionkey" |
    jq -r '.[] | "\(.name) | id: \(.id)"' |
    dmenu_cmd -p "item" |
    cut -d '|' -f 2 |
    cut -d ':' -f 2 |
    tr -d '[:space:]')

# chosen=$(printf "username\npassword" | dmenu_cmd -p "field")
output=$(bw_cmd get item --session "$sessionkey" "$id" |
    jq -r ".login.username, .login.password")

echo "$output" |
    sed -n 1p |
    xclip -i -selection clipboard
echo "$output" |
    sed -n 2p |
    xclip -i -selection primary
