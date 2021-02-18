#!/bin/sh
# todo:
# sound crashes Xorg inconsistently
# tmux send-message

sfxdir="${SFX:-${XDG_DATA_HOME:-${HOME}/.local/share}/sfx}"
soundfont="${SOUNDFONT:-/win95/DA_}"
sfx="${sfxdir}${soundfont}"

notifications="${NOTIFICATIONS:-${XDG_DATA_HOME:-${HOME}/.local/share}/notifications}"
statusbar="${STATUSBAR:-${XDG_DATA_HOME:-${HOME}/.local/share}/statusbar}"

# charlim=25

play(){
    mpv --profile=low-latency --volume="${2:-100}" "${sfx}$1"
}

case $2 in
    pacman) echo "pacman:$(echo $3 | tr -dc '[:digit:]')" >> $statusbar ;;
    neomutt) echo "mail:$(echo $3 | tr -dc '[:digit:]')" >> $statusbar ;;
esac

case $2 in
    newsboat:*) echo "feeds:$(echo $2 | tr -dc '[:digit:]')" >> $statusbar ;;
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
        }" | jq -c >> "$notifications" ;;
esac
