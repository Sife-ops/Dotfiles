#!/bin/bash

if which checkdeps.sh >/dev/null; then
    if ! checkdeps.sh bspc dmenu; then exit 1; fi fi

chosen=$(echo -e \
"add desktop
balance
cycle
edit
equalize
flip horizontal
flip vertical
floating
focus desktop
focus parent
focus window
gaps
insert
kill all windows
kill desktop
kill other desktops
kill other windows
kill window
layout
monocle
move desktop
move to desktop
rename desktop
rotate clockwise
rotate counter-clockwise
split
split up
sticky
swap desktop
tiled
vsplit
vsplit left
zoom" |
dmenu -b -i -l 20 -p "bspc")

case $chosen in
    "add desktop")
        bspc monitor -a \
            $(printf "💻\\n📷\\n🎥\\n💾\\n🎬\\n📀\\n🎶\\n💯\\n🔐\\n" |
            dmenu -b -i -l 20 -p "Enter text: ") ;;
    "flip horizontal") bspc node -F horizontal ;;
    "flip vertical") bspc node -F vertical ;;
    "focus desktop") bspc desktop -f $(deskmenu.sh) ;;
    "focus parent") bspc node @parent -f ;;
    "focus window") bspc node $(winmenu.sh) -f ;;
    "kill all windows") bspc node any.local -c ;;
    "kill window") bspc node "$(winmenu.sh -f)" -c ;;
    "kill other desktops")
        for desktop in $(bspc query -D -m focused -d .\!focused); do
            bspc desktop $desktop -r
        done ;;
    "kill other windows")
        bspc node @/ -i
        bspc node -n $(bspc query -N -d focused -n .leaf.!window)
        bspc node @/1 -c ;;
    "kill desktop") bspc desktop $(deskmenu.sh -f) -r ;;
    "move desktop") bspc desktop focused -m $(monmenu.sh) ;;
    "move to desktop") bspc node -d $(deskmenu.sh) ;;
    "rename desktop")
        bspc desktop focused -n \
            $(printf "💻\\n📷\\n🎥\\n💾\\n🎬\\n📀\\n🎶\\n💯\\n🔐\\n" |
            dmenu -b -i -l 20 -p "Enter text: ") ;;
    "rotate clockwise") bspc node -R 90 ;;
    "rotate counter-clockwise") bspc node -R 270 ;;
    "split up") bspc node --presel-dir north -i ;;
    "swap desktop") bspc desktop -s $(deskmenu.sh) ;;
    "vsplit left") bspc node --presel-dir west -i ;;
    balance) bspc node -B ;;
    cycle) bspc node @parent -C forward ;;
    equalize) bspc node -E ;;
    floating) bspc node -t floating ;;
    insert)
        bspc node $(bspc query -N -n focused) -n \
            $(bspc query -N -d focused -n .leaf.!window) ;;
    layout) bsp-layout set $(layoutmenu.sh) ;;
    monocle) bspc desktop focused -l monocle ;;
    tiled) bspc desktop focused -l tiled ;;
    split) bspc node --presel-dir south -i ;;
    sticky) bspc node -g sticky ;;
    tiled) bspc node -t tiled ;;
    vsplit) bspc node --presel-dir east -i ;;
    zoom) bspc node -s biggest.local ;;
    edit) st -e $EDITOR $0 ;;
    "") exit ;;
    *) eval bspc $chosen ;;
esac
