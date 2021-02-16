#!/bin/sh
# toggle dropdown window

checkdeps.sh xdotool xwininfo dmenu

dmenucmd="${DMENU_CMD:-dmenu -b -i -l 20}"
alias dmenucmd="$dmenucmd"

print_ids(){ #^
    for win in $(xdotool search --class "dd"); do
        printf '%s: %s\n' "$win" "$(xdotool getwindowname "$win")"
    done
} #$

togmap(){ #^
    mapstate=$(xwininfo -id "$1" | awk '/Map State/{print $3}')

    case "$mapstate" in
        IsViewable)
            xdotool windowunmap "$1" ;;
        IsUnMapped)
            xdotool windowmap "$1" ;;
    esac
} #$

#^ main
chosen=$(print_ids | dmenucmd -p "dd" | cut -d ':' -f 1)
case "$chosen" in
    "")
        exit 1 ;;
    *)
        togmap "$chosen" ;;
esac
#$

# vim: fdm=marker fmr=#^,#$
