#!/bin/sh

which checkdeps.sh 1>/dev/null 2>&1 \
    && ( checkdeps.sh jq recursenode.sh || exit 1 )

splitRatio=$(\
    bspc query -T -n @/ -d focused \
    | jq -c '{splitRatio: .root.splitRatio}' \
    | cut -d':' -f2 \
    | tr -d '}' \
)

bspc node @/ -o $splitRatio -p west -i
bspc node $(bspc query -N -n focused.local) -n \
    $(bspc query -N -n .leaf.\!window -d focused)
recursenode.sh @/2 focused.vertical -R 90
bspc node @/2 -B
bspc node -f @/1
