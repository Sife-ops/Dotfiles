#!/bin/sh
# bspc desktop menu

checkdeps.sh bspc dmenu jq bc

#^ setup
dmenucmd="${DMENU_CMD:-dmenu -b -i -l 20}"
alias dmenucmd="$dmenucmd"

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
chosen=$(desk_menu | dmenucmd -p "desktop")
case "$chosen" in
    "") kill 0 ;;
    *) echo "$chosen" | cut -d':' -f3 ;;
esac
#$

# vim: fdm=marker fmr=#^,#$
