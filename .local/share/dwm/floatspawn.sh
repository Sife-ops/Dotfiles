#!/bin/sh

msg_help() { echo "Usage:
    floatspawn.sh [OPTIONS] command
Options:
    -a float        opacity
    -D secs         timed delay
    -l layer        layer to spawn window
    -N              don't auto-hide window
    -p prefix       naming prefix
    -S              xdotool --sync option
    -h              print this message"
    exit 1
}

err_dep() {
    printf "Dependency not installed: %s\\n" "$1"
    exit 1
}

deps=("xdotool" "transset-df")
for dep in ${deps[@]}; do
    which $dep 1>/dev/null || err_dep $dep
done

while getopts "a:D:l:Np:Sh" o; do case "${o}" in
    a) alpha=$OPTARG ;;
    D) secs=$OPTARG ;;
    l) layer=$OPTARG ;;
    N) nohide="true" ;;
    p) prefix=$OPTARG ;;
    S) sync="true" ;;
    h) msg_help ;;
	*) printf "Invalid option: -%s\\n" "$o" && msg_help ;;
esac done
shift $((OPTIND - 1))

# process user input
[ -p /dev/stdin ] && read stdin || stdin=$(floatgrid.sh)
x=$(echo $stdin | cut -d' ' -f1 | cut -d',' -f1)
y=$(echo $stdin | cut -d' ' -f1 | cut -d',' -f2)
w=$(echo $stdin | cut -d' ' -f2 | cut -d'x' -f1)
h=$(echo $stdin | cut -d' ' -f2 | cut -d'x' -f2)
[ -z $layer ] && layer=1
[ -z $prefix ] && prefix="float"

# start programs
if [ -z "$1" ]; then
    msg_help
elif [ "$1" = "$TERMINAL" ]; then
    winname="${prefix}_term"
    xdotool search --name "$winname" || $TERMINAL -c "newfloat" &
else
    winname="${prefix}_${1}"
    xdotool search --name "$winname" || $TERMINAL -c "newfloat" -e "$@" &
fi

# wait for window to spawn
if [ -z $sync ]; then
    while true; do
        xdotool search --class "newfloat" && break
    done
else
    xdotool search --sync --class "newfloat"
fi
[ -z $secs ] || sleep $secs
wid=$(xdotool search --class "newfloat")

# rename window properties
xdotool set_window --name "$winname" "$wid"
xdotool set_window --classname "${prefix}${layer}" "$wid"
xdotool set_window --class "${prefix}" "$wid"

# resize and position windows
xdotool windowunmap $wid
xdotool windowsize $wid $w $h
xdotool windowmove $wid $x $y
[ -z $nohide ] || xdotool windowmap $wid

# make transparent
[ -z $alpha ] || transset-df -i $wid $alpha
