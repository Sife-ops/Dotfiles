#!/bin/sh

msg_help() { echo \
"Usage:
    recursenode.sh TARGET [NODE_SEL] COMMAND

Description:
    Perform node COMMAND on [NODE_SEL] recursively starting from TARGET NODE_SEL."
}

recurseNode() {
    bspc node -f $1
    bspc node $2
    if bspc query -N -n ${1}.leaf >/dev/null; then
        :
    else
        recurseNode "${1}#@1" "$2"
        recurseNode "${1}#@2" "$2"
    fi
}

( [ $# -lt 2 ] || [ $1 = "-h" ] ) && msg_help && exit 1

node_sel=$(bspc query -N -n $1)
shift "$OPTIND"
cmd="$@"

recurseNode "$node_sel" "$cmd"
