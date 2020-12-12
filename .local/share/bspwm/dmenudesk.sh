#!/bin/sh
# bspc desktop menu

if which checkdeps.sh >/dev/null 2>&1; then
    checkdeps.sh bspc dmenu jq bc || exit 1; fi

msg_help() { echo \
"Usage:
    dmenudesk.sh [OPTIONS]

Options:
    -f          display focused desktop first (default: last)
    -h          print this message"
}

while getopts "fh" o; do case "${o}" in
	f) focus="true" ;;
    h) msg_help ;;
	*) printf "Invalid option: -%s\\n" "$o" && msg_help && exit 1 ;;
esac done

[ -z $focus ] && \
    first=$(bc <<< "obase=10; ibase=16; $(bspc query -D -d last | cut -d'x' -f2)") || \
    first=$(bc <<< "obase=10; ibase=16; $(bspc query -D -d focused | cut -d'x' -f2)")

# last=$(bc <<< "obase=10; ibase=16; $(bspc query -D -d last | cut -d'x' -f2)")

chosen=$(\
    bspc wm -d |
        jq '.monitors[] |
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
        tr -d '"' |
        paste - - - -d':' | tac |
        awk "/$first/ { first = \$0 } { print \$0 } END { print first }" | tac |
        dmenu -b -i -l 20 -p "desktop")

case $chosen in
    "") exit ;;
    *) echo $chosen | cut -d':' -f3 ;;
esac
