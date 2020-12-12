#!/bin/sh
# copy emoji to clipboard

if which checkdeps.sh >/dev/null 2>&1; then
    checkdeps.sh xdotool xclip dmenu || exit 1; fi

msg_help() { echo \
"Usage:
    dmenuunicode.sh file"
}

[ -z $1 ] && msg_help && exit 1

chosen=$(cut -d ';' -f1 $1 | dmenu -b -i -l 20 | sed "s/ .*//")

[ -z "$chosen" ] && exit

if [ -n "$1" ]; then
	xdotool type "$chosen"
else
	echo "$chosen" | tr -d '\n' | xclip -selection clipboard
	# notify-send "'$chosen' copied to clipboard." &
fi
