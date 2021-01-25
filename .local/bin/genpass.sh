#!/bin/sh
# generate random password

if which checkdeps.sh 1>/dev/null 2>&1; then
    checkdeps.sh xclip || exit 1; fi

head -c 1024 /dev/urandom |
    tr -dc '`1234567890-=~!@#$%^&*()_+qwertyuiop[]QWERTYUIOP{}asdfghjkl;\ASDFGHJKL:|zxcbnm.ZXCVBNM<>?' |
    sed 's/\(.\{16\}\)\(.*\)/\1/' |
    tee /dev/tty |
    xclip -selection clipboard

echo
