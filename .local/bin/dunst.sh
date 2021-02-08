#!/bin/sh

sfxdir="${SFX:-${XDG_DATA_HOME:-${HOME}/.local/share}/sfx}"
notifications="${NOTIFICATIONS:-${XDG_DATA_HOME:-${HOME}/.local/share}/notifications}"

charlim=25

play(){
    mpv --profile=low-latency --volume="${2:-100}" "$1"
}

case "$2" in
    sfx) play "${sfxdir}/$3" ;;
    *) case "$5" in
            LOW) icon=😁 ;;
            NORMAL) icon=💬 ;;
            CRITICAL) icon=⚠️  ;;
        esac

        appname="$(echo "$1" | sed "s/\(^.\{$charlim\}\)\(.*\)/\1 \.\.\./")"
        summary="$(echo "$2" | sed "s/\(^.\{$charlim\}\)\(.*\)/\1 \.\.\./")"
        body="$(echo "$3" | sed "s/\(^.\{$charlim\}\)\(.*\)/\1 \.\.\./")"
        echo "$icon $appname | $summary | $body $icon" > "$notifications" ;;
esac
