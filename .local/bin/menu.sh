#!/bin/sh
# menu library

#^ runtime checks
[ -f "${CLIPBOARD:=${XDG_DATA_HOME:-${HOME}/.local/share}/clipboard}" ] || \
    nouserclip=t

xset q 1>/dev/null 2>&1 || nox=t

which xclip 1>/dev/null 2>&1 || noxclip=t

which dmenu 1>/dev/null 2>&1 || nodmenu=t
dmenucmd="${DMENU_CMD:-dmenu -b -i -l 20}"

which fzf 1>/dev/null 2>&1 || nofzf=t
fzfcmd="${FZF_CMD:-fzf --tac --cycle}"

if [ -n "$nox" ]; then
        if [ -n "$nofzf" ]; then
            exit 1;
        else
            menucmd="$fzfcmd"
        fi
        clipcmd='cat'
else
    if [ -n "$nodmenu" ]; then
        exit 1;
    else
        menucmd="$dmenucmd"
    fi
    if [ -n "$noxclip" ]; then
        clipcmd='cat'
    else
        clipcmd='xclip'
    fi

    # if [ -n "$PS1" ]; then
    #     menucmd="$fzfcmd"
    # else
    #     if [ -n "$nodmenu" ]; then
    #         exit 1;
    #     else
    #         menucmd="$dmenucmd"
    #     fi
    # fi
    # if [ -n "$noxclip" ]; then
    #     clipcmd='cat'
    # else
    #     clipcmd='xclip'
    # fi

fi
#$

menu(){ #^
    # menu <func. menu> [str. prompt] [bool print_query]
    case "$nox" in
        t) eval "$1 | $menucmd ${2:+--prompt \"$2 \"} ${3:+--print-query}" ;; # sucks
        *) eval "$1 | $menucmd ${2:+-p \"$2\"}" ;;
    esac
} #$

dir_contents(){ #^
    # dir_contents <dir>
    find "$1" -type f -print0 |
    xargs --null -n 1 -I {} basename {}
} #$

clipboard() { #^
    # clipboard <yank|put> <string> [primary]
    case "$1" in
        yank) case "$clipcmd" in
            cat) echo "$2" > "$CLIPBOARD" ;;
            xclip) echo "$2" | eval "xclip -i -selection ${3:-clipboard}" ;;
        esac ;;
        put) case "$clipcmd" in
            cat) cat "$CLIPBOARD" ;;
            xclip) eval "xclip -o -selection ${3:-clipboard}" ;;
        esac ;;
    esac
} #$

# vim: fdm=marker fmr=#^,#$
