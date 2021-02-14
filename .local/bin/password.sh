#!/bin/sh
# interface for bitwarden-cli

. bwvault.sh

secrets(){
    if [ -n "$secrets" ]; then
        echo "$secrets"
    else
        vault | jq -c '[ .[] | select(.type == 1) ]'
    fi
}
secrets="$(secrets)"

secrets_list(){
    secrets | jq -r '.[] | "\(.name) | \(.id)"'
}

get_secret(){
    secrets | jq -c ".[] | select(.id == \"$1\")"
}

get_username(){
    get_secret "$1" | jq -r '.login.username'
}

get_password(){
    get_secret "$1" | jq -r '.login.password'
}

main_list="$(secrets_list)
$(printf "Create ...")
$(printf "Clear cache ...")
$(printf "Logout ...")
$(printf "Sync ...")"
main_list="$(echo "$main_list" | sed '/^$/d')"

field_list="$([ -z "$nox" ] && printf "autofill")
$(printf "both")
$(printf "username")
$(printf "password")
$(printf "Edit ...")"
field_list="$(echo "$field_list" | sed '/^$/d')"

create_list="card
identity
login
secure note"

field_menu(){
    # field_menu <id>
    choose "$field_list" "field"
    case "$chosen" in
        autofill) xdotool type --clearmodifiers "$(get_username "$id")"
                  xdotool key --clearmodifiers Tab
                  xdotool type --clearmodifiers "$(get_password "$id")" ;;
        both) clipboard yank "$(get_username "$id")"
              clipboard yank "$(get_password "$id")" primary ;;
        username) clipboard yank "$(get_username "$id")" ;;
        password) clipboard yank "$(get_password "$id")" ;;
        "Edit ...") edit_item "$(edit "$(get_secret "$id")")" "$id"
                    bw_sync ;;
        "") kill 0 ;;
        *) kill 0 ;;
    esac
}

create_menu(){
    choose "$create_list" "type"
    case "$chosen" in
        card) create_item "$(edit "$(template card)")" ;;
        identity) create_item "$(edit "$(template identity)")" ;;
        login) create_item "$(edit "$(template login)")" ;;
        "secure note") create_item "$(edit "$(template securenote)")" ;;
        "") exit 1 ;;
        *) exit 1 ;;
    esac
    bw_sync
}

choose "$main_list" "secrets"
id="$(echo "$chosen" | cut -d '|' -f 2 | tr -d '[:space:]')"
case "$chosen" in
    "Create ...") create_menu ;;
    "Clear cache ...") bw_clear ;;
    "Logout ...") : ;;
    "Sync ...") bw_sync ;;
    "") exit 1 ;;
    *) field_menu "$id" ;;
esac
