#!/bin/sh
# copy emoji to clipboard

if which checkdeps.sh 1>/dev/null 2>&1; then
    checkdeps.sh xdotool xclip dmenu || exit 1; fi

msg_help() { echo \
"Usage:
    dmenuunicode.sh FILE"
}

if [ -z "$1" ]; then
    msg_help
    exit 1
fi

chosen=$(cut -d ';' -f1 "$1" | dmenu -b -i -l 20 | sed "s/ .*//")
case "$chosen" in
    "") exit 1 ;;
    # *) echo "$chosen" | tr -d '\n' | xclip -selection clipboard ;;
    *) sleep 0.25; xdotool type --clearmodifiers "$chosen" ;;
esac
