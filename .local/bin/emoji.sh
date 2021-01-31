#!/bin/sh
# copy emoji to clipboard

. menu.sh

if which checkdeps.sh 1>/dev/null 2>&1; then
    checkdeps.sh xdotool || exit 1; fi

#^ input
if [ -n "$1" ]; then
   EMOJI="$1"
elif [ -f "${EMOJI:=${XDG_DATA_HOME:-${HOME}/.local/share}/emoji}" ]; then
    :
else
    exit 1
fi
#$

list(){
    cat "$EMOJI"
}

chosen=$(menu list | sed "s/ .*//")
case "$chosen" in
    "") exit 1 ;;
    *) clipboard yank "$chosen"
       sleep 0.25; xdotool type --clearmodifiers "$chosen" ;;
esac

# vim: fdm=marker fmr=#^,#$
