#!/bin/sh
# bw library
# todo:
# todo: verify session key validity
# clientid feature
# shorten bw command

. menu.sh

#^ setup
if which checkdeps.sh 1>/dev/null 2>&1; then
    checkdeps.sh bw gpg jq || exit 1; fi

alias bw_cmd="bw --nointeraction"

bw_session_cache="${BW_SESSION_CACHE:-${XDG_CACHE_HOME:-${HOME}/.cache}/bw-session.gpg}"
if [ -z "$BW_GPG_ID" ]; then
    printf "Error: BW_GPG_ID must be set.\n"
    exit 1
fi
bw_vault_cache="${BW_VAULT_CACHE:-${XDG_CACHE_HOME:-${HOME}/.cache}/bw-vault.gpg}"
#$

bw_login(){ #^
    # bw_login -> session key
    status="$(bw status | jq -r '.userEmail')"
    case "$status" in
        null) bw_session_key="$(bw_cmd login \
              "$(prompt "Username:")" \
              "$(prompt "Password:" t)" --raw)" ;;
        *) bw_session_key="$(bw_cmd unlock "$(prompt "Password:" t)" --raw)" ;;
    esac
    echo "$bw_session_key" |
        gpg --quiet --recipient "$BW_GPG_ID" \
            --encrypt --output "$bw_session_cache"
    printf '%s' "$bw_session_key"
} #$

bw_session_key(){ #^
    # todo: verify session key validity
    if [ -f "$bw_session_cache" ]; then
        bw_session_key=$(gpg --quiet --decrypt "$bw_session_cache")
    else
        bw_session_key=$(bw_login)
    fi
    printf '%s' "$bw_session_key"
} #$

vault(){ #^
    if [ -f "${bw_vault_cache}" ]; then
        gpg --quiet --decrypt "$bw_vault_cache"
    else
        bw_cmd --session "$(bw_session_key)" list items |
            gpg \
                --recipient "$BW_GPG_ID" \
                --output "$bw_vault_cache" \
                --encrypt
        gpg --quiet --decrypt "$bw_vault_cache"
    fi
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
    safe="$(mktemp -d /tmp/bwvault.XXX)"
    chmod 700 "$safe"
    item="$(mktemp "${safe}/bwitem.XXX.json")"
    chmod 600 "$item"
    echo "$1" | jq > "$item"

    buffer "$item"
    while ! cat "$item" | jq 1>/dev/null 2>&1; do
        # message cannot parse json
        buffer "$item"
    done
    cat "$item" | jq -c
    rm -rf "$safe" 1>/dev/null 2>&1
} #$

template(){ #^
    # template <type> -> json
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
    # create_item <id> <json> -> json
    echo "$1" |
        bw_cmd --session "$(bw_session_key)" encode |
        bw_cmd --session "$(bw_session_key)" edit item "$2"
} #$

create_item(){ #^
    # create_item <json> -> json
    echo "$1" |
        bw_cmd --session "$(bw_session_key)" encode |
        bw_cmd --session "$(bw_session_key)" create item
} #$

# vim: fdm=marker fmr=#^,#$
