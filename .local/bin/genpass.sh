#!/bin/sh
# generate random password

if which checkdeps.sh >/dev/null; then
    if ! checkdeps.sh xclip; then exit 1; fi fi

cat /dev/urandom \
    | head -c 1024 \
    | tr -dc '`1234567890-=~!@#$%^&*()_+qwertyuiop[]QWERTYUIOP{}asdfghjkl;\ASDFGHJKL:|zxcbnm.ZXCVBNM<>?' \
    | sed 's/\(.\{16\}\)\(.*\)/\1/' \
    | tee /dev/tty \
    | xclip -selection clipboard
echo
