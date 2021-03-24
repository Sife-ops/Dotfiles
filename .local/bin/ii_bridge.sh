#!/bin/sh

while getopts "n:e" o; do
    case "${o}" in
        n) bridge_name="${OPTARG}" ;;
        e) echo_nick="t" ;;
    esac
done
shift $((OPTIND - 1))

bridge_name="<${bridge_name:-ii_bridge}>"
from="$1"
to="$2"

tail -F -n 1 "$from" | while read a b c d; do
    case "$b" in
        "-!-") : ;;
        *)
            case "$c" in
                "$bridge_name") : ;;
                *) echo "$bridge_name ${echo_nick:+"${b}: "}$c $d" > "$to" ;;
            esac ;;
    esac
done

