#!/bin/sh
# bw library

. menu.sh

#^ setup
if which checkdeps.sh 1>/dev/null 2>&1; then
    checkdeps.sh bw gpg jq || exit 1; fi

alias bw_cmd="bw --nointeraction"

bw_session_cache="${BW_SESSION_CACHE:-$HOME/.cache/bw-session.gpg}"
if [ -z "$BW_GPG_ID" ]; then
    printf "Error: BW_GPG_ID must be set.\n"
    exit 1
fi
#$

bw_session_key(){ #^
    if [ -f "$bw_session_cache" ]; then
        bw_session_key=$(gpg --quiet --decrypt "$bw_session_cache")
    else
        bw_session_key=$(bw_cmd unlock $(printf '' | eval "$menucmd -p \"Password:\"") |
            grep 'export' |
            sed 's/^.*BW_SESSION="\(.*\)"/\1/')
        echo "$bw_session_key" |
            gpg --quiet --recipient "$BW_GPG_ID" \
                --encrypt --output "$bw_session_cache"
    fi
    printf '%s' "$bw_session_key"
} #$

bw_list_items(){ #^
    bw_cmd list items --session "$(bw_session_key)"
} #$

bw_list_logins(){ #^
    bw_list_items |
        jq -c '[ .[] | select(.type == 1) ]'
} #$

bw_list_identities(){ #^
    bw_list_items |
        jq -c '[ .[] | select(.type == 4) ]'
} #$

bw_get_item(){ #^
    bw_cmd get item --session "$(bw_session_key)" "$1"
} #$

bw_logout(){ #^
    rm -f "$bw_session_cache"
} #$

bw_sync(){ #^
    bw_cmd sync --session "$(bw_session_key)"
} #$

# vim: fdm=marker fmr=#^,#$
