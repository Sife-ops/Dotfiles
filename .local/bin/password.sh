#!/bin/sh
# interface for bitwarden-cli
# todo:
# create mode
# edit mode

. menu.sh

#^ setup
while getopts "b:h" o; do
    case "${o}" in
        b) backend="$OPTARG" ;;
        h) msg_help ;;
        *) printf "Invalid option: -%s\n" "$o" ;;
    esac
done
shift $((OPTIND - 1))

if [ -n "$backend" ]; then
    case "$backend" in
        bitwarden) . bwvault.sh ;;
        ipfs) . ipfsvault.sh ;;
        "") exit 1 ;;
        *) exit 1 ;;
    esac
else
    backend="bitwarden"
    . bwvault.sh
fi
#$

secrets(){ #^
    if [ -n "$secrets" ]; then
        echo "$secrets"
    else
        vault | jq -c '[ .[] | select(.type == 1) ]'
    fi
}
secrets="$(secrets)"
#$

secrets_list(){ #^
    secrets | jq -r '.[] | "\(.name) | \(.id)"'
} #$

get_secret(){ #^
    secrets |
        jq -c \
        ".[] |
            select(.id == \"$1\") |
                {
                    username: .login.username,
                    password: .login.password
                }"
} #$

main_list(){ #^
    secrets_list
    [ "$backend" = "bitwarden" ] && printf "Create ...\n"
    [ "$backend" = "bitwarden" ] && printf "Logout ...\n"
    [ "$backend" = "bitwarden" ] && printf "Sync ...\n"
} #$

field_list(){ #^
    printf "both\n"
    printf "username\n"
    printf "password\n"
} #$

field_menu(){ #^
    chosen=$(menu field_list "field")
    case "$chosen" in
        both) clipboard yank "$(get_secret "$1" | jq -r '.username')"
              clipboard yank "$(get_secret "$1" | jq -r '.password')" primary ;;
        username) clipboard yank "$(get_secret "$1" | jq -r '.username')" ;;
        password) clipboard yank "$(get_secret "$1" | jq -r '.password')" ;;
        "") kill 0 ;;
        *) kill 0 ;;
    esac
} #$

#^ main menu
chosen=$(menu main_list "secrets")
case "$chosen" in
    "Create ...") exit 0 ;;
    "Logout ...") bw_logout ;;
    "Sync ...") bw_sync ;;
    "") exit 1 ;;
    *) field_menu "$(echo "$chosen" | cut -d '|' -f 2 | tr -d '[:space:]')" ;;
esac
#$

# vim: fdm=marker fmr=#^,#$
