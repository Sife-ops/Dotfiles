#!/bin/sh
# bw functions
# todo:
# verify session key validity
# clientid feature
# shorten bw command
# better username/password prompt

checkdeps.sh bw gpg jq

. menu.sh

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

bw_login(){ #^
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

} #$

bw_session_key(){ #^
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
} #$

vault(){ #^
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

} #$

bw_sync(){ #^
    bw_cmd --session "$(bw_session_key)" sync
    rm -rf "$bw_vault_cache"
} #$

bw_clear(){ #^
    rm -f "$bw_session_cache"
    rm -f "$bw_vault_cache"
} #$

edit(){ #^
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

} #$

template(){ #^
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

} #$

edit_item(){ #^
    # edit_item <id> <json> -> json
    # changes a vault item in your Bitwarden vault

    echo "$1" |
        bw_cmd --session "$(bw_session_key)" encode |
        bw_cmd --session "$(bw_session_key)" edit item "$2"

} #$

create_item(){ #^
    # create_item <json> -> json
    # creates a new item in your Bitwarden vault

    echo "$1" |
        bw_cmd --session "$(bw_session_key)" encode |
        bw_cmd --session "$(bw_session_key)" create item

} #$

delete_item(){ #^
    # delete_item <id>
    # creates a new item in your Bitwarden vault

    bw_cmd --session "$(bw_session_key)" delete item "$1"

} #$

# vim: fdm=marker fmr=#^,#$
