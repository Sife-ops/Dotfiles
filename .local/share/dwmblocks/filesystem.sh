#!/bin/sh
# print filesystem usage

df -h | grep -v '^Filesystem\|^dev\|^run\|^tmpfs\|/efi' |
    while read dev size used avail use mount; do
        if [ "$(echo $use | tr -dc '[:digit:]')" -ge 90 ]; then
            warn='❗'; else warn=''; fi
        printf '💽%s:%s%s ' \
            "$(basename $mount)" \
            "$use" \
            "$warn"
    done
