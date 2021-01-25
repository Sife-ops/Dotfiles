#!/bin/sh
# dmenu interface for bitwarden-cli
# todo:
# create mode
# edit mode

#^ setup
# consider using:
# set -E
# trap '[ "$?" -ne 77 ] || exit 77' ERR

alias bw_cmd="bw --nointeraction"
alias dmenu_cmd="${DMENU_CMD:-dmenu -b -i -l 20}" # failing shellcheck
alias prompt_cmd="printf '' | dmenu_cmd -p 'Password:'"
# alias prompt_cmd="zenity --password"
# alias prompt_cmd='yad --entry --entry-label="Password: " --hide-text'

if which checkdeps.sh 1>/dev/null 2>&1; then
    checkdeps.sh dmenu bw gpg jq xclip || exit 1; fi

session_cache="${BW_SESSION_CACHE:-$HOME/.cache/bw-session.gpg}"
if [ -z "$BW_GPG_ID" ]; then
    printf "" | dmenu_cmd -p "Error: BW_GPG_ID must be set."
    exit 1
fi
#$

login(){ #^
    if [ ! -f "$session_cache" ]; then
        session_key=$(bw_cmd unlock "$(prompt_cmd)" |
            grep 'export' |
            sed 's/^.*BW_SESSION="\(.*\)"/\1/')
        echo "$session_key" |
            gpg --quiet --recipient "$BW_GPG_ID" \
                --encrypt --output "$session_cache"
    else
        session_key=$(gpg --quiet --decrypt "$session_cache")
    fi
} #$

print_items(){ #^
    if bw_cmd list items --session "$session_key"; then
        :
    else
        printf "" | dmenu_cmd -p "Error: Bad session key."
        rm -f "$session_cache"
        kill 0 # consider using exit 77
    fi | jq -r '.[] | "\(.name) | id: \(.id)"'
} #$

logout_(){ #^
    rm -f "$session_cache"
} #$

sync(){ #^
    bw_cmd sync --session "$session_key"
} #$

get(){ #^
    id=$(printf '%s' "$1" |
    cut -d '|' -f 2 |
    cut -d ':' -f 2 |
    tr -d '[:space:]')

    output=$(bw_cmd get item --session "$session_key" "$id" |
        jq -r ".login.username, .login.password")
    printf '%s' "$output" |
        sed -n 1p |
        xclip -i -selection clipboard
    printf '%s' "$output" |
        sed -n 2p |
        xclip -i -selection primary
} #$

#^ main menu
login

chosen=$(  (print_items;
            printf "Create ...\n";
            printf "Logout ...\n";
            printf "Sync ...\n";) |
                dmenu_cmd -p "Bitwarden")

case "$chosen" in
    "Create ...")
        exit 0
        ;;
    "Logout ...")
        logout_; exit 0
        ;;
    "Sync ...")
        sync; exit 0
        ;;
    "")
        exit 1
        ;;
    *)
        get "$chosen"; exit 0
        ;;
esac
#$

# vim: fdm=marker fmr=#^,#$
