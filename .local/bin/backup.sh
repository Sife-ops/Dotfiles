#!/bin/sh
# backup utility

config_dir="${XDG_CONFIG_HOME}/backup"
config="${config_dir}/config"
[ -e "$config" ] || exit 1

while read host target; do

    case $host in
        "$(cat /etc/hostname)") : ;;
        "#"|"") continue ;;
        *) continue ;;
    esac

    mkdir -p "$target" 2>/dev/null
    [ -d "$(readlink -f "$target")" ] || continue

    cd "$target"
    [ -e "./backup.conf" ] \
        && backup_conf="./backup.conf" \
        || backup_conf="${config_dir}/backup.conf"
    [ -e "$backup_conf" ] || continue

    mkdir "./${host}" 2>/dev/null
    [ -d "./${host}" ] || continue

    while read a b; do
        case $a in
            "$host") rsync \
                -av \
                -R \
                --update \
                --delete \
                "$b" "./${host}" ;;
            "#"|"") continue ;;
            *) continue ;;
        esac
    done < "$backup_conf"

done < "$config"
