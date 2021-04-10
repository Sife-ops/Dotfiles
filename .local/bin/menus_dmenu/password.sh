#!/bin/sh
# dmenu wrapper for bitwarden
# todo: diff edited file with original

passwordFile="${SECRETS}/bitwarden.gpg"

case $(bw status | jq -r '.status') in
    unlocked) : ;;
    *) echo "your session was locked" # change to notify-send
        password=$(gpg --decrypt "$passwordFile" 2>/dev/null)
        sessionKey=$(bw unlock $password --raw)

        # need to generalize
        echo "export BW_SESSION=\"${sessionKey}\"" > \
            "${ZDOTDIR}/conf.d/99-bitwarden.zsh"
        export BW_SESSION=$sessionKey

        # final confirmation
        case $(bw status | jq -r '.status') in
            unlocked) : ;;
            *) echo "login failed" ;; # change to notify-send
        esac ;;
esac

main_list () {
    bw list items | jq -r '.[] | "\(.name) | \(.id)"'
    echo "Create"
    echo "Sync"
}

item_list () {
    echo "Copy"
    echo "Edit"
    echo "Delete"
}

create_list () {
    echo "card"
    echo "identity"
    echo "login"
    echo "secure note"
}

template () {
    # $1 -> item type string, => item json
    # generate a template for new items
    item="$(bw get template item)"
    template="$(bw get template item."$1")"
    item="$(echo "$item" | jq -c ".$1 = $template")"
    item="$(echo "$item" | jq -c ".name = \"<++>\"")"
    item="$(echo "$item" | jq -c ".notes = null")"
    case "$1" in
        identity) item="$(echo "$item" | jq -c '.type = 1')" ;;
        secureNote) item="$(echo "$item" | jq -c '.type = 2')" ;;
        card) item="$(echo "$item" | jq -c '.type = 3')" ;;
        login) item="$(echo "$item" | jq -c ".login.username = \"<++>\"")"
            # password=$(< /dev/urandom tr -dc 'A-Za-z0-9' | head -c 16)
            password=$(< /dev/urandom tr -dc 'A-Za-z0-9!@#$%^&*()-=_+[]~{}|;:,./<>?' | head -c 16)
            item="$(echo "$item" | jq -c ".login.password = \"${password}\"")"
            uri="$(bw get template item.login.uri)"
            item="$(echo "$item" | jq -c ".login.uris = [${uri}]")"
            item="$(echo "$item" | jq -c ".login.uris[0].uri = null")"
            # echo "$password" | xclip -i -selection clipboard # doesn't work
            tmux set-buffer "$password" ;;
        "") kill 0 ;;
        *) kill 0 ;;
    esac
    echo "$item"
}

edit () {
    # $1 -> item json, => edited item json
    # edit vault items in a restricted folder
    # todo: diff edited item with original

    # create secure temp files for editing vault items
    safe="$(mktemp -d /tmp/bw.XXXXX)"
    chmod 700 "$safe"

    item="$(mktemp "${safe}/bw.XXXXX.json")"
    chmod 600 "$item"
    echo "$1" | jq > "$item"

    # original="$(mktemp "${safe}/bw.XXXXX.json")"
    # chmod 600 "$original"
    # cp "$item" "$original"

    # open item with text editor
    $TERMEXEC $EDITOR $item

    # never accept invalid json
    while ! cat "$item" | jq 1>/dev/null 2>&1; do
        # message cannot parse json
        $TERMEXEC $EDITOR $item
    done

    # # kill if no change
    # if diff -q "$item" "$original"; then
    #     rm -rf "$safe" 1>/dev/null 2>&1
    #     kill 0
    # else

    cat "$item" | jq -c
    rm -rf "$safe" 1>/dev/null 2>&1

    # fi

}

create_item () {
    # $1 -> item json
    # create a new item in your Bitwarden vault
    echo "$1" |
        bw encode |
        bw create item
}

edit_item () {
    # $1 -> item json, $2 -> id
    # eidt a vault item in your Bitwarden vault
    echo "$1" |
        bw encode |
        bw edit item "$2"
}

chosen=$(main_list | ${DMENU_CMD:-dmenu})
case "$chosen" in
    Create)
        chosen=$(create_list | ${DMENU_CMD:-dmenu})
        case "$chosen" in
            card) create_item "$(edit "$(template card)")" ;;
            identity) create_item "$(edit "$(template identity)")" ;;
            login) create_item "$(edit "$(template login)")" ;;
            "secure note") create_item "$(edit "$(template securenote)")" ;;
        esac
        ;;
    Sync) bw sync -f ;;
    "") exit 1 ;;
    *)
        id=$(echo "$chosen" | cut -d '|' -f 2 | tr -d '[:space:]')
        item=$(bw list items | jq -c ".[] | select(.id == \"$id\")")
        chosen=$(item_list | ${DMENU_CMD:-dmenu})
        case "$chosen" in
            Copy)
                echo "$item" | jq
                username=$(echo "$item" | jq -r '.login.username')
                password=$(echo "$item" | jq -r '.login.password')
                echo "$username" | xclip -i -selection clipboard
                echo "$password" | xclip -i -selection primary
                tmux set-buffer "$username"
                tmux set-buffer "$password"
                ;;
            Edit) edit_item "$(edit "$item")" $id ;;
            Delete) bw delete item $id ;;
        esac
        ;;
esac
bw sync -f
