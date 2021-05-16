#!/bin/sh
# exercise in obfuscated code

while IFS=" " read a b c d e f; do
    case $a in
        ''|'#'*) : ;;
        *) case $f in
                '0') printf "%s;%s\n" $a $b ;;
            esac ;;
    esac
done < /etc/fstab |
    while IFS=";" read drive mount; do
        unset mounted
        mount | grep $drive 1>/dev/null 2>&1 \
            && mounted=Y
        printf "%s %s -> %s\n" ${mounted:-N} $drive $mount
    done | ${DMENU_CMD:-dmenu -i -l 5} |
        while IFS=" " read mounted fs none mount; do
            case $mounted in
                Y) umount $mount ;;
                N) mount $mount ;;
            esac
        done
