#!/bin/sh
# password manager for bitwarden and dmenu/fzf

checkdeps(){
    program="$0"

    for dep in "$@"; do
        if ! which "$dep" 1>/dev/null 2>&1; then
            if [ -z "$deps" ]; then
                deps="${dep}:"
            else
                deps="${deps}${dep}:"
            fi
        fi
    done

    if [ -n "$deps" ]; then
        len="$(echo "$deps" | tr -dc ':')"
        len="${#len}"
        for ind in $(seq $len); do
            dep="$(echo "$deps" | cut -d ':' -f "$ind")"
            printf '%s: %s dependency "%s" not installed.\n' \
                "${0##/*/}" \
                "$program" \
                "$dep"
            notify-send \
                --urgency=critical \
                "${0##/*/}" \
                "$program dependency $dep not installed."
        done
        kill 0
    fi
}

checkdeps bw gpg jq

clipboard="${CLIPBOARD:-${XDG_DATA_HOME:-${HOME}/.local/share}/clipboard}"
[ -d "$clipboard" ] || mkdir -p "$clipboard"

alias dmenucmd="${DMENU_CMD:-dmenu -b -i -l 20}"
alias fzfcmd="${FZF_CMD:-fzf --tac --cycle}"

nox="${MENU_NOX}"
case "$nox" in
    "") checkdeps dmenu yad ;;
    *) checkdeps fzf dialog ;;
esac

choose(){
    case "$nox" in
        "") chosen="$(echo "$1" | dmenucmd ${2:+-p "$2"})" ;;
        *) chosen="$(echo "$1" | fzfcmd ${2:+--prompt "$2 "})" ;;
    esac
}

prompt() {
    # prompt <string prompt> [bool password] -> string
    case "$nox" in
        "")
            if [ -n "$2" ]; then
                yad --text-align=center --text="$1" --entry --hide-text
            else
                yad --text-align=center --text="$1" --entry
            fi ;;
        *)
            if [ -n "$2" ]; then
                dialog --passwordbox "$1" 10 60 3>&1 1>&2 2>&3 3>&1
            else
                dialog --inputbox "$1" 10 60 3>&1 1>&2 2>&3 3>&1
            fi ;;
    esac
}

clipboard() {
    # clipboard yank <string> [clipboard|primary|secondary]
    # clipboard put [clipboard|primary|secondary]
    case "$nox" in
        "") case $1 in
            yank) printf '%s' "$2" | xclip -i -selection ${3:-clipboard} 2>/dev/null ;;
            put) xclip -o -selection ${2:-clipboard} 2>/dev/null ;;
        esac ;;
        *) case $1 in
            yank) case "$3" in
                    clipboard) printf '%s' "$2" > "${clipboard}/00" ;;
                    primary) printf '%s' "$2" > "${clipboard}/01" ;;
                    secondary) printf '%s' "$2" > "${clipboard}/02" ;;
                    "") printf '%s' "$2" > "${clipboard}/00" ;;
                esac ;;
            put) case "$2" in
                    clipboard) cat "${clipboard}/00" ;;
                    primary) cat "${clipboard}/01" ;;
                    secondary) cat "${clipboard}/02" ;;
                    "") cat "${clipboard}/00" ;;
                esac ;;
        esac ;;
    esac
}

buffer(){
    # buffer <file>
    case "$nox" in
        "") ${TERMINAL:-xterm} -e ${EDITOR:-nano} $1 ;;
        *) ${EDITOR:-nano} $1 ;;
    esac
}

dir_contents(){
    # dir_contents <dir>
    find "$1" -type f -print0 |
    xargs --null -I {} basename {}
}
config="${XDG_CONFIG_HOME:-${HOME}/.config}/bwvault/config"
bw_session_cache="${BW_SESSION_CACHE:-${XDG_CACHE_HOME:-${HOME}/.cache}/bw-session.gpg}"
bw_vault_cache="${BW_VAULT_CACHE:-${XDG_CACHE_HOME:-${HOME}/.cache}/bw-vault.gpg}"

alias bw_cmd="bw --nointeraction"

# read configuration file
while IFS= read -r line; do
    case "$line" in
        '#'*) : ;;
        *) eval "$line" ;;
    esac
done < "$config"

# require a GPG ID for encrypting cache files
if [ -z "$BW_GPG_ID" ]; then
    printf "Error: BW_GPG_ID must be set.\n"
    exit 1
fi

bw_login(){
    # bw_login -> session key

    # check whether logged in
    status="$(bw status | jq -r '.userEmail')"
    case "$status" in

        # log into Bitwarden
        null) bw_session_key="$(bw_cmd login \
              "$(prompt "Username:")" \
              "$(prompt "Password:" t)" --raw)" ;;

        # unlock Bitwarden
        *) bw_session_key="$(bw_cmd unlock "$(prompt "Password:" t)" --raw)" ;;
    esac

    # store session key in an encrypted file
    echo "$bw_session_key" |
        gpg --quiet --recipient "$BW_GPG_ID" \
            --encrypt --output "$bw_session_cache"

    # print session key
    printf '%s' "$bw_session_key"

}

bw_session_key(){
    # bw_session_key -> session key
    # todo: verify session key validity

    # decrypt session key or log in
    if [ -f "$bw_session_cache" ]; then
        bw_session_key=$(gpg --quiet --decrypt "$bw_session_cache")
    else
        bw_session_key=$(bw_login)
    fi

    # print session key
    printf '%s' "$bw_session_key"
}

vault(){
    # vault -> vault json

    # download and encrypt vault json cache
    if [ ! -f "${bw_vault_cache}" ]; then
        bw_cmd --session "$(bw_session_key)" list items |
            gpg \
                --recipient "$BW_GPG_ID" \
                --output "$bw_vault_cache" \
                --encrypt
    fi

    # decrypt cached vault json
    gpg --quiet --decrypt "$bw_vault_cache"

}

bw_sync(){
    bw_cmd --session "$(bw_session_key)" sync
    rm -rf "$bw_vault_cache"
}

bw_clear(){
    rm -f "$bw_session_cache"
    rm -f "$bw_vault_cache"
}

edit(){
    # edit <json> -> json
    # edits vault items in a restricted folder
    # todo: diff edited item with original

    # create secure temp files for editing vault item
    safe="$(mktemp -d /tmp/bwvault.XXX)"
    chmod 700 "$safe"
    item="$(mktemp "${safe}/bwitem.XXX.json")"
    chmod 600 "$item"
    echo "$1" | jq > "$item"

    # open vault item with text editor
    buffer "$item"

    # never accept invalid json
    while ! cat "$item" | jq 1>/dev/null 2>&1; do
        # message cannot parse json
        buffer "$item"
    done

    # print edited vault item
    cat "$item" | jq -c

    # delete temp files
    rm -rf "$safe" 1>/dev/null 2>&1

}

template(){
    # template <identity|secureNote|card|login> -> json
    # generates valid bitwarden vault item json for a new vault item

    item="$(bw_cmd --session "$(bw_session_key)" get template item)"
    template="$(bw_cmd --session "$(bw_session_key)" get template item."$1")"
    item="$(echo "$item" | jq -c ".$1 = $template")"
    item="$(echo "$item" | jq -c ".notes = null")"
    case "$1" in
        identity)
            item="$(echo "$item" | jq -c '.type = 1')" ;;
        secureNote)
            item="$(echo "$item" | jq -c '.type = 2')" ;;
        card)
            item="$(echo "$item" | jq -c '.type = 3')" ;;
        login)
            uri="$(bw_cmd --session "$(bw_session_key)" get template item.login.uri)"
            item="$(echo "$item" | jq -c ".login.uris = [${uri}]")"
            item="$(echo "$item" | jq -c ".login.uris[0].uri = null")" ;;
        "") kill 0 ;;
        *) kill 0 ;;
    esac
    echo "$item"

}

edit_item(){
    # edit_item <id> <json> -> json
    # changes a vault item in your Bitwarden vault

    echo "$1" |
        bw_cmd --session "$(bw_session_key)" encode |
        bw_cmd --session "$(bw_session_key)" edit item "$2"

}

create_item(){
    # create_item <json> -> json
    # creates a new item in your Bitwarden vault

    echo "$1" |
        bw_cmd --session "$(bw_session_key)" encode |
        bw_cmd --session "$(bw_session_key)" create item

}

delete_item(){
    # delete_item <id>
    # creates a new item in your Bitwarden vault

    bw_cmd --session "$(bw_session_key)" delete item "$1"

}

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
# main_list="$(echo "$main_list" | sed '/^$/d')"

field_list="$(printf "both")
$(printf "username")
$(printf "password")
$(printf "Edit ...")
$(printf "Delete ...")"
# field_list="$(echo "$field_list" | sed '/^$/d')"

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
        "Delete ...") delete_item "$id"
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
