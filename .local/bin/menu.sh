#!/bin/sh
# menu library

#^ runtime checks
xset q 1>/dev/null 2>&1 || nox=t

which xclip 1>/dev/null 2>&1 || noxclip=t

which dmenu 1>/dev/null 2>&1 || nodmenu=t
dmenucmd="${DMENU_CMD:-dmenu -b -i -l 20}"

which fzf 1>/dev/null 2>&1 || nofzf=t
fzfcmd="${FZF_CMD:-fzf}"

if [ -n "$nox" ]; then
        if [ -n "$nofzf" ]; then
            exit 1;
        else
            menucmd="$fzfcmd"
        fi
        clipcmd='cat'
else
    if [ -n "$PS1" ]; then
        menucmd="$fzfcmd"
    else
        if [ -n "$nodmenu" ]; then
            exit 1;
        else
            menucmd="$dmenucmd"
        fi
    fi
    if [ -n "$noxclip" ]; then
        clipcmd='cat'
    else
        clipcmd='xclip'
    fi
fi
#$

menu(){ #^
    eval "$1 | $menucmd ${2:+-p "$2"}" # no word splitting
} #$

clipboard() { #^
    case "$1" in
        yank) case "$clipcmd" in
            cat) echo "$2" > "$CLIPBOARD" ;;
            xclip) echo "$2" | xclip -i -selection clipboard ;;
        esac ;;
        put) case "$clipcmd" in
            cat) cat "$CLIPBOARD" ;;
            xclip) xclip -o -selection clipboard ;;
        esac ;;
    esac
} #$

# vim: fdm=marker fmr=#^,#$
