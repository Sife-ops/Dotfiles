#!/bin/sh
# dmenu bspc wrapper
# todo:
# command cache

#^ setup
if which checkdeps.sh 1>/dev/null 2>&1; then
    checkdeps.sh bspc jq bc dmenu || exit 1; fi

alias dmenucmd='dmenu -b -i -l 20'
#$

choose(){ #^
    # choose STRING [PROMPT] [NO_FORMAT]
    # changes external $chosen
    chosen=$(\
        if [ -z "$3" ]; then
            printf '%s' "$1"
        else
            printf '%s' "$1"
        fi | eval dmenucmd ${2:+"-p \"$2\""} )
    echo "$chosen"
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
#$

domain=$(choose "$domains" "domain")
cmd="bspc $domain"

case $domain in #^
    node) chosen=$(dmenunode.sh) ;;
    desktop) chosen=$(dmenudesk.sh) ;;
    monitor) chosen=$(dmenumon.sh) ;;
    wm) : ;;
esac
cmd="$cmd $chosen" #$

case $domain in #^
    node) choose "$optsNode" "options" >/dev/null ;;
    desktop) choose "$optsDesk" "options" >/dev/null ;;
    monitor) choose "$optsMon" "options" >/dev/null ;;
    wm) choose "$optsWm" "options" >/dev/null ;;
esac
chosen=$(echo "$chosen" | cut -d ',' -f 1)
cmd="$cmd $chosen" #$

case $domain in #^

    node) case $chosen in #^
        -f|-a|-n|-s) chosen=$(dmenunode.sh) ;;
        -d) chosen=$(dmenudesk.sh) ;;
        -m) chosen=$(dmenumon.sh) ;;
        -p) choose "north\nwest\nsouth\neast" "direction" 1 >/dev/null ;; # [~]DIR|cancel
        -o) choose "0.25\n0.33\n0.50\n0.75" "ratio" 1 >/dev/null ;; # RATIO
        -r) choose "0.25\n0.33\n0.50\n0.75" "ratio" 1 >/dev/null ;; # RATIO|(+|-)(PIXELS|FRACTION)
        -R) choose "90\n270\n180" "degrees" 1 >/dev/null ;; # 90|270|180
        -F) choose "horizontal\nvertical" "orentation" 1 >/dev/null ;; # horizontal|vertical
        -C) choose "forward\nbackward" "direction" 1 >/dev/null ;; # forward|backward
        -t) choose "tiled\npseudo_tiled\nfloating\nfullscreen" "state" 1 >/dev/null ;; # [~](tiled|pseudo_tiled|floating|fullscreen)
        -g) choose "hidden\nsticky\nprivate\nlocked\nmarked" "flag" 1 >/dev/null ;; # hidden|sticky|private|locked|marked[=on|off]
        -l) choose "below\nnormal\nabove" "layer" 1 >/dev/null ;; # below|normal|above
        -v) choose "50 50" "dx dy" 1 >/dev/null ;; # dx dy
        -z) choose "top\nleft\nbottom\nright\ntop_left\ntop_right\nbottom_right\nbottom_left" "edge" 1 >/dev/null
            cmd="$cmd $chosen"
            choose "50 50" "dx dy" 1 >/dev/null ;; # top|left|bottom|right|top_left|top_right|bottom_right|bottom_left dx dy
        -E|-B|-i|-c|-k) echo "$cmd" && exit 0 ;;
    esac ;; #$

    desktop) case $chosen in #^
        -f|-a|-s) chosen=$(dmenudesk.sh) ;; # , --focus [DESKTOP_SEL]
        -l|-b) choose "next\nprev" "cycle" 1 >/dev/null ;; # , --layout CYCLE_DIR|monocle|tiled
        -m) chosen=$(dmenumon.sh) ;; # , --to-monitor MONITOR_SEL [--follow]
        -n) choose "" "name" >/dev/null ;; # , --rename <new_name>
        -r) echo "$cmd" && exit 0 ;;
    esac ;; #$

    monitor) case $chosen in #^
        -f|-s) chosen=$(dmenumon.sh) ;; # , --focus [MONITOR_SEL]
        -a) choose "" "name" >/dev/null ;; # , --add-desktops <name>...
        -n) choose "" "name" >/dev/null ;; # , --rename <new_name>
        -o) choose "" "name" >/dev/null ;; # , --reorder-desktops <name>...
        -d) choose "" "name" >/dev/null ;; # , --reset-desktops <name>...
        -g) choose "" "WxH+X+Y" >/dev/null ;; # , --rectangle WxH+X+Y
        -r) echo "$cmd" && exit 0 ;;
    esac ;; #$

    wm) case $chosen in #^
        -r) echo "$cmd" && exit 0 ;;
        # -d) : ;; # , --dump-state
        # -l) : ;; # , --load-state <file_path>
        # -a) : ;; # , --add-monitor <name> WxH+X+Y
        # -O) : ;; # , --reorder-monitors <name>...
        # -o) : ;; # , --adopt-orphans
        # -h) : ;; # , --record-history on|off
        # -g) : ;; # , --get-status
    esac ;; #$

esac
cmd="$cmd $chosen" #$

eval "$cmd" # what the fuck??

# vim: fdm=marker fmr=#^,#$
