#!/bin/sh
# check dependencies

if xset q 1>/dev/null 2>&1; then
    dialog_cmd(){
        gxmessage "$1"
    }
else
    dialog_cmd(){
        dialog --msgbox "$1" 10 60
    }
fi

for dep in "$@"; do
    which "$dep" 1>/dev/null 2>&1 || deps="$deps $dep"
done

if [ -n "$deps" ]; then
    dialog_cmd "$deps"
    exit 1
fi
