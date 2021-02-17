#!/bin/sh
# bspc window menu

checkdeps.sh bspc jq bc dmenu

#^ setup
dmenucmd="${DMENU_CMD:-dmenu -b -i -l 20}"
alias dmenucmd="$dmenucmd"

msg_help() { echo \
"Usage:
    dmenunode.sh [OPTIONS]

Options:
    -f          display focused window first (default: last)
    -h          print this message"
}

while getopts "fhk" o; do case "${o}" in
	f) focused="focused" ;;
    k) killzero=t ;;
    h) msg_help ;;
	*) printf "Invalid option: -%s\\n" "$o" && msg_help && exit 1 ;;
esac done
#$

nodes(){ #^
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

node_list(){ #^
    first_item=$(echo "ibase=16; $(bspc query -N -n "${focused:-last}" | cut -d 'x' -f 2)" | bc)
    nodes |
        tac |
        awk "/$first_item/ { first = \$0 } { print \$0 } END { print first }" |
        tac
} #$

chosen="$(node_list | dmenucmd -p "node")"
case "$chosen" in
    "") [ -n "$killzero" ] && kill 0 ;;
    *) echo "$chosen" | cut -d ':' -f 4 ;;
esac

# vim: fdm=marker fmr=#^,#$
