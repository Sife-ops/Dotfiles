#!/bin/sh
# bspc desktop menu

#^ setup
if which checkdeps.sh 1>/dev/null 2>&1; then
    checkdeps.sh bspc dmenu jq bc || exit 1; fi

DMENU_CMD="${DMENU_CMD:-dmenu -b -i -l 20}"
alias dmenucmd="$DMENU_CMD"

msg_help() { echo \
"Usage:
    dmenudesk.sh [OPTIONS]

Options:
    -f          display focused desktop first (default: last)
    -h          print this message"
}

while getopts "fh" o; do case "${o}" in
	f) focused="focused" ;;
    h) msg_help ;;
	*) printf "Invalid option: -%s\\n" "$o" && msg_help && exit 1 ;;
esac done
#$

print_desks(){ #^
    bspc wm -d |
        jq -r \
            '.monitors[] |
            {
                monitor: .name,
                desktop: .desktops[] |
                {
                    name: .name,
                    id: .id
                }
            } |
            .monitor,
            .desktop.name,
            .desktop.id' |
                paste - - - -d':'
} #$

desk_menu(){ #^
    first_item=$(echo "ibase=16; $(bspc query -D -d "${focused:-last}" |
        cut -d 'x' -f 2)" |
        bc)
    print_desks |
        tac |
        awk "/$first_item/ { first = \$0 } { print \$0 } END { print first }" |
        tac
} #$

#^ main
notify-send "sfx" "win95/DA_MENU.WAV"
chosen=$(desk_menu | dmenucmd -p "desktop")
case "$chosen" in
    "") kill 0 ;;
    *) echo "$chosen" | cut -d':' -f3 ;;
esac
#$

# vim: fdm=marker fmr=#^,#$
