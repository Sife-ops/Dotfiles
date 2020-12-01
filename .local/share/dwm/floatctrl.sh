#!/bin/sh
# hide/show windows

msg_help() { echo "Usage:
    ddctrl.sh [OPTIONS] action
Options:
    -a          perform action on all
    -l LAYER    perform action on layer
    -n NAME     perform action on window name
    -p PREFIX   target windows with PREFIX
    -h          print this message
Actions:
    toggle
    show
    hide"
    exit 1
}

err_dep() {
    printf "Dependency not installed: %s\\n" "$1"
    exit 1
}

deps=("xdotool")
for dep in ${deps[@]}; do
    which $dep 1>/dev/null || err_dep $dep
done

while getopts "al:n:p:h" o; do case "${o}" in
    a) opt="class" ;;
    l) opt="classname"; optarg="${OPTARG}";;
    n) opt="name"; optarg="${OPTARG}";;
    p) prefix="${OPTARG}";;
    h) msg_help ;;
	*) printf "Invalid option: -%s\\n" "$o" && msg_help ;;
esac done
shift $((OPTIND - 1))

[ -z $opt ] && opt="class"
[ -z $prefix ] && prefix="float"

[ "$opt" = "class" ] && arg=$prefix
[ "$opt" = "classname" ] && arg="${prefix}${optarg}"
[ "$opt" = "name" ] && arg="${prefix}_${optarg}"

for wid in $(xdotool search --${opt} "$arg"); do
    case $1 in
        toggle )
            if xdotool search --onlyvisible --name $(xdotool getwindowname $wid); then
                xdotool windowunmap $wid
            else
                xdotool windowmap $wid
            fi
        ;;
        show )
            xdotool windowmap $wid ;;
        hide )
            xdotool windowunmap $wid ;;
    esac
done
