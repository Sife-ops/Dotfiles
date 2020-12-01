#!/bin/sh
# move focused floating window

msg_help() { echo "Usage:
    floatmove.sh [OPTIONS] dir
Options:
    -i PIXELS   increment size"
    exit 1
}

err_dep() {
    printf "Dependency not installed: %s\\n" "$1"
    exit 1
}

while getopts "i:" o; do case "${o}" in
    i) increment=${OPTARG} ;;
    h) msg_help ;;
	*) printf "Invalid option: -%s\\n" "$OPTARG" && msg_help ;;
esac done
shift $((OPTIND - 1))

deps=("xdotool")
for dep in ${deps[@]}; do
    which $dep 1>/dev/null || err_dep $dep
done

# process user input
wid=$(xdotool getactivewindow)
tmpfile="/tmp/${wid}_floatmove.tmp"
if [ -p /dev/stdin ]; then
    read fgrid
elif [ -f $tmpfile ]; then
    fgrid=$(cat $tmpfile)
else
    fgrid=$(floatgrid.sh)
fi
col=$(echo $fgrid | cut -d' ' -f3 | cut -d',' -f1)
row=$(echo $fgrid | cut -d' ' -f3 | cut -d',' -f2)
cols=$(echo $fgrid | cut -d' ' -f4 | cut -d'x' -f1)
rows=$(echo $fgrid | cut -d' ' -f4 | cut -d'x' -f2)
gap=$(echo $fgrid | cut -d' ' -f5)
tstrut=$(echo $fgrid | cut -d' ' -f6)
bstrut=$(echo $fgrid | cut -d' ' -f7)

if [ -z $increment ]; then
    case "$1" in
        up)
            row=$(( row - 1 ))
            [ $row -lt 1 ] && row=1 ;;
        down)
            row=$(( row + 1 ))
            [ $row -gt $rows ] && row=$rows ;;
        left)
            col=$(( col - 1 ))
            [ $col -lt 1 ] && col=1 ;;
        right)
            col=$(( col + 1 ))
            [ $col -gt $cols ] && col=$cols ;;
        incrows)
            rows=$(( rows + 1 )) ;;
        decrows)
            rows=$(( rows - 1 ))
            [ $rows -lt 1 ] && rows=1 ;;
        inccols)
            cols=$(( cols + 1 )) ;;
        deccols)
            cols=$(( cols - 1 ))
            [ $cols -lt 1 ] && cols=1 ;;
    esac
    fgrid=$(\
        floatgrid.sh \
        -x $col \
        -y $row \
        -c $cols \
        -r $rows \
        -g $gap \
        -t $tstrut \
        -b $bstrut \
    )
    x=$(echo $fgrid | cut -d' ' -f1 | cut -d',' -f1)
    y=$(echo $fgrid | cut -d' ' -f1 | cut -d',' -f2)
    w=$(echo $fgrid | cut -d' ' -f2 | cut -d'x' -f1)
    h=$(echo $fgrid | cut -d' ' -f2 | cut -d'x' -f2)
    xdotool windowsize $wid $w $h
    xdotool windowmove $wid $x $y
else
    case "$1" in
        up)     xdotool windowmove --relative $wid x -${increment} ;;
        down)   xdotool windowmove --relative $wid x $increment ;;
        left)   xdotool windowmove --relative $wid -${increment} y ;;
        right)  xdotool windowmove --relative $wid $increment y ;;
    esac
fi

# write tempfile
echo $fgrid > $tmpfile
