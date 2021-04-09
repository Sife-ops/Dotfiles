#!/bin/sh
# todo:
# channels, verify identification
# test whether can join channels
# dcc

prefix="${IRC:-${XDG_DATA_HOME}/ii}"
servers="${prefix}/servers"
session_log="${prefix}/session_log"

networks="${XDG_CONFIG_HOME}/ii/networks"
passwords="${XDG_CONFIG_HOME}/ii/passwords"

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

# kill running instances of ii
pgrep -x ii && pkill -x ii
mkdir -p "$servers" || exit 1
find "$servers" -name 'in' -exec rm {} \;
[ -f "$session_log" ] && rm "$session_log"

while read server port nick bot channels; do
    # ignore comments/empty lines
    if [ "$server" = "#" ] || [ -z "$server" ]; then continue; fi

    # start ii
    ii -i $servers -s $server -p $port -n $nick 1>"$session_log" 2>&1 &

    server_pipe="${servers}/${server}/in"

    # wait for server pipe to be created
    pinwheel "connecting to $server "
    while [ ! -e "$server_pipe" ]; do
        sleep 0.2
        pinwheel "connecting to $server "
    done
    printf "\n"

    # decrypt password
    case $bot in
        "_") : ;;
        *)
            pinwheel "decrypting password "
            printf "\n"
            password=$(gpg \
                --decrypt "${passwords}/${server}~${nick}.gpg" \
                2>"$session_log")
            ;;
    esac

    case $bot in
        "&bitlbee"|"nickserv")
            bot_pipe="${servers}/${server}/${bot}/in"
            bot_log="${servers}/${server}/${bot}/out"

            # wait for bot pipe to become active
            pinwheel "waiting for bots "
            while [ ! -e "$bot_pipe" ]; do
                [ -e "$server_pipe" ] && \
                    printf "/j %s echo\n" "$bot" > "$server_pipe"
                sleep 0.2
                pinwheel "waiting for bots "
            done
            printf "\n"

            # identify
            [ -f "$bot_log" ] && truncate -s 0 "$bot_log"
            printf "identify %s\n" "$password" > "$bot_pipe"
            case "$bot" in
                "&bitlbee") magic_word=accepted ;;
                "nickserv") magic_word=identified ;;
            esac

            # wait to be identified
            pinwheel "identifying $nick on $server "
            while ! grep "$magic_word" "$bot_log" 1>"$session_log" 2>&1 ; do
                sleep 0.2
                pinwheel "identifying $nick on $server "
            done
            printf "\n"
            ;;

        znc)
            # wait for server pipe to be created
            while [ ! -e "$server_pipe" ]; do
                sleep 0.2
            done

            # identify
            pinwheel "identifying $nick on $server "
            printf "\n"
            printf "/PASS %s/%s:%s\n" \
                "$nick" "$channels" "$password" > "$server_pipe"
            ;;
    esac
done < "$networks"
