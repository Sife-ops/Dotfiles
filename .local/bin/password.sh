#!/bin/sh
# interface for bitwarden-cli

. menu.sh

while getopts "b:h" o; do
    case "${o}" in
        b) backend="$OPTARG" ;;
        h) msg_help ;;
        *) printf "Invalid option: -%s\n" "$o" ;;
    esac
done

if [ -n "$backend" ]; then
    case "$backend" in
        bitwarden)  . bwvault.sh ;;
        ipfs)       . ipfsvault.sh ;;
        github)     . ghvault.sh ;;
        "") exit 1 ;;
        *) exit 1 ;;
    esac
else
    backend="bitwarden"
    . bwvault.sh
fi

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
$([ "$backend" = "bitwarden" ] && printf "Create ...\n")
$([ "$backend" = "bitwarden" ] && printf "Logout ...\n")
$([ "$backend" = "bitwarden" ] && printf "Sync ...\n")"

field_list="$([ -z "$nox" ] && printf "autofill\n")
$(printf "both\n")
$(printf "username\n")
$(printf "password\n")
$(printf "Edit ...\n")"

field_menu(){
    # field_menu <id>
    choose "$field_list" "field"
    case "$chosen" in
        autofill)
            xdotool type --clearmodifiers "$(get_username "$id")"
            xdotool key --clearmodifiers Tab
            xdotool type --clearmodifiers "$(get_password "$id")" ;;
        both) clipboard yank "$(get_username "$id")"
              clipboard yank "$(get_password "$id")" primary ;;
        username) clipboard yank "$(get_username "$id")" ;;
        password) clipboard yank "$(get_password "$id")" ;;
        "Edit ...") edit_item "$(edit "$(get_secret "$id")")" "$id" ;;
        "") kill 0 ;;
        *) kill 0 ;;
    esac
}

choose "$main_list" "secrets"
id="$(echo "$chosen" | cut -d '|' -f 2 | tr -d '[:space:]')"
case "$chosen" in
    "Create ...") bwcreate.sh ;;
    "Logout ...") bw_logout ;;
    "Sync ...") bw_sync ;;
    "") exit 1 ;;
    *) field_menu "$id" ;;
esac
