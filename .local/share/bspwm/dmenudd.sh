#!/bin/sh
# toggle dropdown window

#^ setup
if which checkdeps.sh 1>/dev/null 2>&1; then
    checkdeps.sh xdotool xwininfo dmenu || exit 1; fi

DMENU_CMD="${DMENU_CMD:-dmenu -b -i -l 20}"
alias dmenucmd="$DMENU_CMD"
#$

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
chosen=$(print_ids | dmenu_cmd -p "dd" | cut -d ':' -f 1)
case "$chosen" in
    "")
        exit 1 ;;
    *)
        togmap "$chosen" ;;
esac
#$

# vim: fdm=marker fmr=#^,#$
