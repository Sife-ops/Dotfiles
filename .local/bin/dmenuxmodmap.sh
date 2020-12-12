#!/bin/sh
# change keyboard map

if which checkdeps.sh >/dev/null 2>&1; then
    checkdeps.sh dmenu || exit 1; fi

maps="${XDG_DATA_HOME:-${HOME}/.local/share}/xmodmap"

chosen=$(\
    { for file in $(find $maps -name '*.map'); do
        basename $file
    done } |
    awk 'BEGIN { print "default" } { print $0 }' |
    dmenu -b -i -l 20 -p "xmodmap")

case $chosen in
    default)
        setxmodmap.sh default ;;
    *)
        ln -sf ${maps}/${chosen} ${maps}/xmodmap
        setxmodmap.sh ;;
esac
