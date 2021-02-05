#!/bin/sh

password_file="${XDG_DATA_HOME:-${HOME}/.local/share}/gnupg/sifeatircdotfreenodedotnet.gpg"
password="$(gpg --decrypt "$password_file" 2>/dev/null |
    sed 's/\\/\\\\/g' |
    sed 's/\$/\\\$/g' |
    sed 's/\&/\\\&/g' |
    sed 's/\*/\\\*/g' |
    sed 's/\./\\\./g' |
    sed 's/\//\\\//g' |
    sed 's/\^/\\\^/g')"

sed -i "s/<++>/$password/" config
irssi --config="${XDG_CONFIG_HOME:-${HOME}/.config}/irssi/config" \
      --home="${XDG_CONFIG_HOME:-${HOME}/.config}/irssi"
sed -i "s/$password/<++>/" config
