#!/bin/sh
# interface for bitwarden-cli
# todo:
# create mode
# edit mode

. bw.sh

main_list(){ #^
    bw_list_logins | jq -r '.[] | "\(.name) | \(.id)"'
    printf "Create ...\n"
    printf "Logout ...\n"
    printf "Sync ...\n"
} #$

field_list(){ #^
    printf "both\n"
    printf "username\n"
    printf "password\n"
} #$

field_menu(){ #^
    # field_menu <id>
    secret=$(bw_get_item "$1" |
        jq -c "{username: .login.username, password: .login.password}")
    chosen=$(menu field_list "field")
    case "$chosen" in
        both) clipboard yank "$(echo "$secret" | jq -r '.username')"
              clipboard yank "$(echo "$secret" | jq -r '.password')" primary ;;
        username) clipboard yank "$(echo "$secret" | jq -r '.username')" ;;
        password) clipboard yank "$(echo "$secret" | jq -r '.password')" ;;
        "") kill 0 ;;
        *) kill 0 ;;
    esac
} #$

#^ main menu
chosen=$(menu main_list "Bitwarden")
case "$chosen" in
    "Create ...") exit 0 ;;
    "Logout ...") bw_logout ;;
    "Sync ...") bw_sync ;;
    "") exit 1 ;;
    *) field_menu "$(echo "$chosen" | cut -d '|' -f 2 | tr -d '[:space:]')" ;;
esac
#$

# vim: fdm=marker fmr=#^,#$
