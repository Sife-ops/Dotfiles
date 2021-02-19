#!/bin/sh
# todo:
# sound crashes Xorg inconsistently
# tmux send-message

sfx="${SFX:-${XDG_DATA_HOME:-${HOME}/.local/share}/sfx}"

notifications="${NOTIFICATIONS:-${XDG_DATA_HOME:-${HOME}/.local/share}/notifications}"
statusbar="${STATUSBAR:-${XDG_DATA_HOME:-${HOME}/.local/share}/statusbar}"

play(){
    mpv --profile=low-latency --volume="${2:-100}" "${sfx}/$1"
}

updateStatusMaybePlay(){
    count=$(echo "$1" | tr -dc '[:digit:]')
    if [ "$count" -gt 0 ]; then
        echo "feeds:$count" >> "$statusbar"
        play "$2"
    fi
}

case "$2" in
    newsboat:*) updateStatusMaybePlay "$2" "win95/DA_DEFAU.WAV" ;;
    pacman) updateStatusMaybePlay "$2" "win95/DA_EMPTY.WAV" ;;
    neomutt) updateStatusMaybePlay "$2" "win95/DA_ERROR.WAV" ;;
esac

case "$2" in
    sfx) play "$3" ;;
    *) echo \
        "{
            \"appname\": \"$1\",
            \"summary\": \"$2\",
            \"body\": \"$3\",
            \"icon\": \"$4\",
            \"urgency\": \"$5\"
        }" | jq -c >> "$notifications"
        sleep 10
        echo >> "$notifications" ;;
esac
