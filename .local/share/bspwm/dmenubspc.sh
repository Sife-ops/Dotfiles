#!/bin/sh
# dmenu bspc wrapper
# todo:
# command cache

#^ setup
if which checkdeps.sh 1>/dev/null 2>&1; then
    checkdeps.sh bspc dmenu || exit 1; fi

DMENU_CMD="${DMENU_CMD:-dmenu -b -i -l 20}"
alias dmenucmd="$DMENU_CMD"
#$

choose(){ #^
    # choose STRING [PROMPT] -> string
    notify-send "sfx" "win95/DA_MENU.WAV"
    printf '%s' "$1" | eval "dmenucmd ${2:+-p \"$2\"}"
} #$

# menus #^
domains='node
desktop
monitor
wm'

optsNode='-f, --focus [NODE_SEL]
-a, --activate [NODE_SEL]
-d, --to-desktop DESKTOP_SEL [--follow]
-m, --to-monitor MONITOR_SEL [--follow]
-n, --to-node NODE_SEL [--follow]
-s, --swap NODE_SEL [--follow]
-p, --presel-dir [~]DIR|cancel
-o, --presel-ratio RATIO
-v, --move dx dy
-z, --resize top|left|bottom|right|top_left|top_right|bottom_right|bottom_left dx dy
-r, --ratio RATIO|(+|-)(PIXELS|FRACTION)
-R, --rotate 90|270|180
-F, --flip horizontal|vertical
-E, --equalize
-B, --balance
-C, --circulate forward|backward
-t, --state [~](tiled|pseudo_tiled|floating|fullscreen)
-g, --flag hidden|sticky|private|locked|marked[=on|off]
-l, --layer below|normal|above
-i, --insert-receptacle
-c, --close
-k, --kill'

optsDesk='-f, --focus [DESKTOP_SEL]
-a, --activate [DESKTOP_SEL]
-m, --to-monitor MONITOR_SEL [--follow]
-s, --swap DESKTOP_SEL [--follow]
-l, --layout CYCLE_DIR|monocle|tiled
-n, --rename <new_name>
-b, --bubble CYCLE_DIR
-r, --remove'

optsMon='-f, --focus [MONITOR_SEL]
-s, --swap MONITOR_SEL
-a, --add-desktops <name>...
-o, --reorder-desktops <name>...
-d, --reset-desktops <name>...
-g, --rectangle WxH+X+Y
-n, --rename <new_name>
-r, --remove'

optsWm='-d, --dump-state
-l, --load-state <file_path>
-a, --add-monitor <name> WxH+X+Y
-O, --reorder-monitors <name>...
-o, --adopt-orphans
-h, --record-history on|off
-g, --get-status
-r, --restart'

dir='north
west
south
east'

ratio='0.25
0.33
0.50
0.75'

degrees='90
270
180'

orientation='horizontal
vertical'

direction='forward
backward'

state='tiled
pseudo_tiled
floating
fullscreen'

flag='hidden
sticky
private
locked
marked'

layer='below
normal
above'

dxdy='50 50
25 25'

edge='top
left
bottom
right
top_left
top_right
bottom_right
bottom_left'

cycle='next
prev'
#$

domain=$(choose "$domains" "domain")
cmd="bspc $domain"

case $domain in #^
    node) chosen=$(dmenunode.sh -f) ;;
    desktop) chosen=$(dmenudesk.sh -f) ;;
    monitor) chosen=$(dmenumon.sh -f) ;;
    wm) : ;;
    "") exit 1 ;;
    *) exit 1 ;;
esac
cmd="$cmd $chosen" #$

case $domain in #^
    node) chosen=$(choose "$optsNode" "options") ;;
    desktop) chosen=$(choose "$optsDesk" "options") ;;
    monitor) chosen=$(choose "$optsMon" "options") ;;
    wm) chosen=$(choose "$optsWm" "options") ;;
    "") exit 1 ;;
    *) exit 1 ;;
esac
chosen=$(echo "$chosen" | cut -d ',' -f 1)
cmd="$cmd $chosen" #$

case $domain in #^
    node) case $chosen in #^
        -f|-a|-n|-s) chosen=$(dmenunode.sh -f) ;;
        -d) chosen=$(dmenudesk.sh -f) ;;
        -m) chosen=$(dmenumon.sh -f) ;;
        -p) chosen=$(choose "$dir" "direction") ;; # [~]DIR|cancel
        -o) chosen=$(choose "$ratio" "ratio") ;; # RATIO
        -r) chosen=$(choose "$ratio" "ratio") ;; # RATIO|(+|-)(PIXELS|FRACTION)
        -R) chosen=$(choose "$degrees" "degrees") ;; # 90|270|180
        -F) chosen=$(choose "$orientation" "orientation") ;; # horizontal|vertical
        -C) chosen=$(choose "$direction" "direction") ;; # forward|backward
        -t) chosen=$(choose "$state" "state") ;; # [~](tiled|pseudo_tiled|floating|fullscreen)
        -g) chosen=$(choose "$flag" "flag") ;; # hidden|sticky|private|locked|marked[=on|off]
        -l) chosen=$(choose "$layer" "layer") ;; # below|normal|above
        -v) chosen=$(choose "$dxdy" "dx dy") ;; # dx dy
        -z) chosen=$(choose "$edge" "edge")
            cmd="$cmd $chosen"
            chosen=$(choose "$dxdy" "dx dy") ;; # top|left|bottom|right|top_left|top_right|bottom_right|bottom_left dx dy
        # -E|-B|-i|-c|-k) echo "$cmd" && exit 0 ;;
        # -E|-B|-i|-c|-k) eval "$cmd"; exit ;;
        -E|-B|-i|-c|-k) chosen="" ;;
        "") exit 1 ;;
        *) exit 1 ;;
    esac ;; #$

    desktop) case $chosen in #^
        -f|-a|-s) chosen=$(dmenudesk.sh -f) ;; # , --focus [DESKTOP_SEL]
        -l|-b) chosen=$(choose "cycle" "cycle") ;; # , --layout CYCLE_DIR|monocle|tiled
        -m) chosen=$(dmenumon.sh -f) ;; # , --to-monitor MONITOR_SEL [--follow]
        -n) chosen=$(choose "" "name") ;; # , --rename <new_name>
        -r) chosen="" ;;
        "") exit 1 ;;
        *) exit 1 ;;
    esac ;; #$

    monitor) case $chosen in #^
        -f|-s) chosen=$(dmenumon.sh -f) ;; # , --focus [MONITOR_SEL]
        -a) chosen=$(choose "" "name") ;; # , --add-desktops <name>...
        -n) chosen=$(choose "" "name") ;; # , --rename <new_name>
        -o) chosen=$(choose "" "name") ;; # , --reorder-desktops <name>...
        -d) chosen=$(choose "" "name") ;; # , --reset-desktops <name>...
        -g) chosen=$(choose "" "WxH+X+Y") ;; # , --rectangle WxH+X+Y
        -r) chosen="" ;;
        "") exit 1 ;;
        *) exit 1 ;;
    esac ;; #$

    wm) case $chosen in #^
        -r) eval "$cmd"; exit ;;
        # -d) : ;; # , --dump-state # open in buffer?
        # -l) : ;; # , --load-state <file_path>
        # -a) : ;; # , --add-monitor <name> WxH+X+Y
        # -O) : ;; # , --reorder-monitors <name>...
        # -o) : ;; # , --adopt-orphans
        # -h) : ;; # , --record-history on|off
        # -g) : ;; # , --get-status
        "") exit 1 ;;
        *) exit 1 ;;
    esac ;; #$
esac
cmd="$cmd $chosen" #$

notify-send "sfx" "win95/DA_MENUC.WAV"
eval "$cmd"

# vim: fdm=marker fmr=#^,#$
