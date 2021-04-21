#!/bin/sh

color1="\033[1;37m"
color2="\033[1;32m"
color3="\033[0;33m"

main () {
    tail ${1:+-F} -n ${1:-100} "./out" | while read time nick text; do
        case "$nick" in
            "-!-") : ;;
            *) case "$text" in
                "!"*) : ;;
                "@"*) : ;;
                *) time="$(date --date="@${time}" | awk '{print $4}')"
                    nick="$(echo "${nick}:" | tr -d '<>')"
                    printf "%b%s %b%s %b%s\n" \
                        "$color1" "$time" \
                        "$color2" "$nick" \
                        "$color3" "$text"
                    [ -n "$1" ] && notify-send "${0##/*/}" "$nick $text"
                    # [ -n "$1" ] && mpv "${SFX}/AOL/receive.flac" 1>/dev/null 2>&1 & ;;
            esac ;;
        esac
    done
}

refresh () {
    clear
    main
}

trap refresh SIGINT

main
while true; do
    main 0
done
