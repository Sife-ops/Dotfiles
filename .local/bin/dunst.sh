#!/bin/sh
# sound crashes Xorg inconsistently

sfxdir="${SFX:-${XDG_DATA_HOME:-${HOME}/.local/share}/sfx}"
soundfont="${SOUNDFONT:-/win95/DA_}"
sfx="${sfxdir}${soundfont}"

notifications="${NOTIFICATIONS:-${XDG_DATA_HOME:-${HOME}/.local/share}/notifications}"

charlim=25

play(){
    mpv --profile=low-latency --volume="${2:-100}" "${sfx}$1"
}

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
