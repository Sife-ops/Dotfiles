#!/bin/sh

. bwvault.sh

main_list(){ #^
    printf "create\n"
    printf "edit\n"
} #$

create_list(){ #^
    printf "card\n"
    printf "identity\n"
    printf "login\n"
    printf "secure note\n"
} #$

create_menu(){ #^
    chosen=$(menu create_list "type")
    case "$chosen" in
        card) create_item "$(edit "$(template card)")" ;;
        identity) create_item "$(edit "$(template identity)")" ;;
        login) create_item "$(edit "$(template login)")" ;;
        "secure note") create_item "$(edit "$(template securenote)")" ;;
        "") exit 1 ;;
        *) exit 1 ;;
    esac
} #$

#^ main menu
chosen=$(menu main_list "manage")
case "$chosen" in
    "create") create_menu ;;
    # "edit") edit_menu ;;
    "edit") : ;;
    "") exit 1 ;;
    *) exit 1 ;;
esac
#$

bw_sync

# vim: fdm=marker fmr=#^,#$
