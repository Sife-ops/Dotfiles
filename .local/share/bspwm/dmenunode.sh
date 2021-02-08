#!/bin/sh
# bspc window menu

#^ setup
if which checkdeps.sh 1>/dev/null 2>&1; then
    checkdeps.sh bspc jq bc dmenu || exit 1; fi

DMENU_CMD="${DMENU_CMD:-dmenu -b -i -l 20}"
alias dmenucmd="$DMENU_CMD"

msg_help() { echo \
"Usage:
    dmenunode.sh [OPTIONS]

Options:
    -f          display focused window first (default: last)
    -h          print this message"
}

while getopts "fh" o; do case "${o}" in
	f) focused="focused" ;;
    h) msg_help ;;
	*) printf "Invalid option: -%s\\n" "$o" && msg_help && exit 1 ;;
esac done
#$

print_nodes(){ #^
    bspc wm -d |
        jq -r \
            '.monitors[] |
            {
                monitor: .name,
                desktop: .desktops[] |
                {
                    name: .name,
                    window: ( .. | .root?, .firstChild?, .secondChild?) |
                    {
                        id: .id,
                        name: .client.className
                    }
                }
            } |
            select(.desktop.window.name != null) |
            .monitor,
            .desktop.name,
            .desktop.window.name,
            .desktop.window.id' |
                paste - - - - -d':'
} #$

node_menu(){ #^
    first_item=$(echo "ibase=16; $(bspc query -N -n "${focused:-last}" |
        cut -d 'x' -f 2)" |
        bc)
    print_nodes |
        tac |
        awk "/$first_item/ { first = \$0 } { print \$0 } END { print first }" |
        tac
} #$

#^ main
chosen=$(node_menu | dmenucmd -p "node")
case "$chosen" in
    "") kill 0 ;; # consider changing
    *) echo "$chosen" | cut -d ':' -f 4 ;;
esac
#$

# vim: fdm=marker fmr=#^,#$
