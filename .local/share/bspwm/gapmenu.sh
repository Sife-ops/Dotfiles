#!/bin/sh

if which checkdeps.sh >/dev/null; then
    if ! checkdeps.sh bspc dmenu; then exit 1; fi fi

chosen=$(echo -e \
"0
10
20
30
40
50" |
dmenu -b -i -l 20 -p "size")

echo $chosen
