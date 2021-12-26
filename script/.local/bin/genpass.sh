#!/bin/sh
# generate random password

clipboard="${CLIPBOARD:-${HOME}/.local/share/clipboard}"

pass="$(head -c 1024 /dev/urandom |
    tr -dc '1234567890-=~!@#$%^&*()_+qwertyuiop[]QWERTYUIOP{}asdfghjkl;ASDFGHJKL:|zxcbnm.ZXCVBNM<>?' |
    sed 's/\(.\{16\}\)\(.*\)/\1/')"

echo "$pass"

if which xclip 1>/dev/null 2>&1; then
    echo "$pass" | xclip -i -selection clipboard
fi

if [ -f "${clipboard}/00" ]; then
    echo "$pass" > "${clipboard}/00"
fi
