#!/bin/sh
# dmenu interface for bitwarden-cli
# todo:
# create mode
# edit mode

. bw.sh

yank(){ #^
    id=$(printf '%s' "$1" |
    cut -d '|' -f 2 |
    cut -d ':' -f 2 |
    tr -d '[:space:]')
    output=$(bw_get_item "$id" |
        jq -r ".login.username, .login.password")
    printf '%s' "$output" |
        sed -n 1p |
        xclip -i -selection clipboard
    printf '%s' "$output" |
        sed -n 2p |
        xclip -i -selection primary
} #$

main_list(){ #^
    bw_list_logins | jq -r '.[] | "\(.name) | id: \(.id)"'
    printf "Create ...\n"
    printf "Logout ...\n"
    printf "Sync ...\n"
} #$

#^ main menu
chosen=$(menu main_list "Bitwarden")
case "$chosen" in
    "Create ...") exit 0 ;;
    "Logout ...") bw_logout; exit 0 ;;
    "Sync ...") bw_sync; exit 0 ;;
    "") exit 1 ;;
    *) yank "$chosen"; exit 0 ;;
esac
#$

# vim: fdm=marker fmr=#^,#$
