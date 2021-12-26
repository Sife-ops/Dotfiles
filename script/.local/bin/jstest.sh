#!/bin/sh
# run jstest on all joysticks

if [ ! -e /dev/input/js0 ]; then
    notify-send --urgency=critical "${0##/*/}" "No devices detected."
    exit 1
fi

find /dev/input -regex '.*/js[0-9]' |
    while read device; do
        name=$(basename $device)
        tmux new-session -d -s $name "jstest $device"
        ${TERMEXEC:-xterm -e} tmux attach-session -t $name &
    done
