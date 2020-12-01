#!/bin/sh

msg_help() { echo \
"Usage:
    winmenu.sh [OPTIONS]

Options:
    -f          display focused window first (default: last)
    -h          print this message"
}

if which checkdeps.sh >/dev/null; then
    if ! checkdeps.sh bspc jq bc dmenu; then exit 1; fi fi

while getopts "fh" o; do case "${o}" in
	f) focus="true" ;;
    h) msg_help ;;
	*) printf "Invalid option: -%s\\n" "$o" && msg_help && exit 1 ;;
esac done

[ -z $focus ] && \
    first=$(bc <<< "obase=10; ibase=16; $(bspc query -N -n last | cut -d'x' -f2)") || \
    first=$(bc <<< "obase=10; ibase=16; $(bspc query -N -n focused | cut -d'x' -f2)")

chosen=$(\
    bspc wm -d |
        jq '.monitors[] |
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
        tr -d '"' |
        paste - - - - -d':' | tac |
        awk "/$first/ { first = \$0 } { print \$0 } END { print first }" | tac |
        dmenu -b -i -l 20 -p "window")

case $chosen in
    "") exit ;;
    *) echo $chosen | cut -d':' -f4 ;;
esac
