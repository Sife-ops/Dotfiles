#!/bin/sh
# todo:
# channels, verify identification
# test whether can join channels
# dcc

prefix="${HOME}/.local/share/ii"
session_log="${prefix}/session_log"
networks="${prefix}/networks"
servers="${prefix}/servers"
passwords="${prefix}/passwords"

pinwheel="\\"
pinwheel () {
    case "$pinwheel" in
        "\\") pinwheel="/" ;;
        "/") pinwheel="-" ;;
        "-") pinwheel="\\" ;;
    esac
    if [ -n "$1" ]; then
        for i in $(seq ${#1}); do
            printf "\r"
        done
        printf "\r%s%s" "$1" "$pinwheel"
    else
        printf "\r%s" "$pinwheel"
    fi
}

pgrep -x ii && pkill -x ii
mkdir -p "$servers" || exit 1
[ -f "$session_log" ] && rm "$session_log"

while read server nick bot channels; do

    if [ "$server" = "#" ] || [ -z "$server" ]; then continue; fi
    ii -i $servers -s $server -n $nick 1>"$session_log" 2>&1 &
    # ii -i $servers -s $server -n $nick &

    server_pipe="${servers}/${server}/in"

    if [ ! "$bot" = "_" ]; then

        bot_pipe="${servers}/${server}/${bot}/in"
        bot_log="${servers}/${server}/${bot}/out"
        password=$(gpg --decrypt "${passwords}/${server}~${nick}.gpg")

        while [ ! -e "$bot_pipe" ]; do
            [ -e "$server_pipe" ] && \
                printf "/j %s echo\n" "$bot" > "$server_pipe"
            pinwheel "connecting to $server "
        done
        printf "\n"

        [ -f "$bot_log" ] && truncate -s 0 "$bot_log"
        printf "identify %s\n" "$password" > "$bot_pipe"
        case "$bot" in
            "nickserv") magic_word=identified ;;
            "&bitlbee") magic_word=ready ;;
        esac
        while ! grep "$magic_word" "$bot_log"; do
            pinwheel "identifying $nick on $server "
        done
        printf "\n"

    fi

    if [ -n "$channels" ]; then

        ind=$(echo "$channels" | tr -dc ',')
        ind=${#ind}

        printf "waiting to join channels ...\n"
        sleep ${1:-10}

        for i in $(seq $(( $ind + 1 )) ); do
            channel=$(echo "$channels" | cut -d ',' -f "$i")
            [ -e "$server_pipe" ] && \
                printf "/j %s\n" "$channel" > "$server_pipe"
        done

    fi

done < "$networks"
