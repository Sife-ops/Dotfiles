#!/bin/sh

config="./backup.conf"
[ -f "$config" ] || exit 1

host="$(cat /etc/hostname)"
mkdir "./${host}" 2>/dev/null

while read a b; do
    case $a in
        '#'|'') : ;;
        "$host") rsync \
            -av \
            -R \
            --update \
            --delete \
            "$b" "./${host}" ;;
        *) : ;;
    esac
done < "$config"
