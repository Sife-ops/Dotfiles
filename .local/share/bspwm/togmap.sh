#!/bin/sh

if which checkdeps.sh >/dev/null 2>&1; then
    checkdeps.sh xdotool xwininfo || exit 1; fi

msg_help() { echo \
"Usage:
    togmap.sh [OPTIONS] PATTERN

Description:
    Toggle window map-state on or off.

Options:
    -c  perform action on class PATTERN
    -l  perform action on classname PATTERN
    -n  perform action on window name PATTERN
    -h  print this message"
}

while getopts "clnh" o; do case "${o}" in
    c) opt="--class" ;;
    l) opt="--classname" ;;
    n) opt="--name" ;;
    h) msg_help && exit 0 ;;
	*) printf "Invalid option: -%s\\n" "$o" && msg_help && exit 1 ;;
esac done
shift $((OPTIND - 1))

[ -z $opt ] && opt="--name"
[ -z $1 ] && msg_help && exit 1

for wid in $(xdotool search $opt $1); do

    mapstate=$(xwininfo -id $wid | awk '/Map State/{print $3}')

    case "$mapstate" in
        IsViewable)
            xdotool windowunmap $wid ;;
        IsUnMapped)
            xdotool windowmap $wid ;;
    esac
done
