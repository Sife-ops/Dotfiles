#!/bin/sh
# check dependencies

msg() {
    echo -n "Dependency not installed: $@" \
        | tee /dev/tty | gxmessage -file - 2>/dev/null &
    exit 1
}

for dep in $@; do
    which $dep 1>/dev/null 2>&1 || deps="$deps $dep"
done

[ -z "$deps" ] || msg $deps
