#!/bin/sh
# a grid for floating windows

msg_help() { echo "Usage:
    floatgrid.sh [OPTIONS] command
Options:
    -c COLS         number of columns
    -r ROWS         number of rows
    -x COL          columns
    -y ROW          rows
    -g PIXELS       gap size
    -t PIXELS       top strut
    -b PIXELS       bottom strut
    -h              print this message"
    exit 1
}

err_dep() {
    printf "Dependency not installed: %s\\n" "$1"
    exit 1
}

deps=("xrandr")
for dep in ${deps[@]}; do
    which $dep 1>/dev/null || err_dep $dep
done

while getopts "c:r:x:y:g:t:b:h" o; do case "${o}" in
    c) cols=$OPTARG ;;
    r) rows=$OPTARG ;;
    x) col=$OPTARG ;;
    y) row=$OPTARG ;;
    g) gap=$OPTARG ;;
    t) tstrut=$OPTARG ;;
    b) bstrut=$OPTARG ;;
    h) msg_help ;;
	*) printf "Invalid option: -%s\\n" "$o" && msg_help ;;
esac done
shift $((OPTIND - 1))

# process user input
[ -z $cols ] && cols=2
[ -z $rows ] && rows=2
[ -z $col ] && col=1
[ -z $row ] && row=1
cols_=$(( cols - 1 ))
rows_=$(( rows - 1 ))
col_=$(( col - 1 ))
row_=$(( row - 1 ))
[ -z $gap ] && gap=50
gap_=$(( gap / 2 ))
[ -z $tstrut ] && tstrut=0
[ -z $bstrut ] && bstrut=0

# calculate window size and position
res=$(xrandr|grep '*')
monw=$(echo $res|cut -d'x' -f1|tr -d '[:space:]')
monh=$(( $(echo $res|cut -d'x' -f2|cut -d' ' -f1) - bstrut ))
monw=$(( monw - $(( gap_ * 2 )) ))
monh=$(( monh - $(( gap_ * 2 )) ))
w_=$(( monw / ( cols_ + 1 ) ))
x_=("$gap_")

i=0
while [ $i -lt $cols_ ]; do
    x_+=("$(( ${x_[$i]} + w_ ))")
    i=$(( i + 1 ))
done

h_=$(( monh / ( rows_ + 1 ) ))
# y_=("$gap_")
y_=("$(( gap_ + tstrut ))")
i=0
while [ $i -lt $rows_ ]; do
    y_+=("$(( ${y_[$i]} + h_ ))")
    i=$(( i + 1 ))
done

x=$(( ${x_[$col_]} + gap_ ))
y=$(( ${y_[$row_]} + gap_ ))
w=$(( w_ - ( gap_ * 2 ) ))
h=$(( h_ - ( gap_ * 2 ) ))

# output
echo "${x},${y} ${w}x${h} ${cols}x${rows} ${col},${row} $gap $tstrut $bstrut"
