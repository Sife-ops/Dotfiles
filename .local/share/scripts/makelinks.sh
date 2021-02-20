#!/bin/sh

hostname="$(cat /etc/hostname)"

while read host item; do
    case "$host" in
        '#'*) : ;;
        '') : ;;
        "$hostname") ln -sfn "${PWD}/${hostname}/${item}" "$item" ;;
        'default') ln -sfn "${PWD}/default/${item}" "$item" ;;
    esac
done < ./makelinks.conf
