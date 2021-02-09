#!/bin/sh
# menu library
# todo:
# implement yad

# alias dialogcmd
# alias yadcmd
# alias zenitycmd
dmenucmd="${DMENU_CMD:-dmenu -b -i -l 20}"
fzfcmd="${FZF_CMD:-fzf --tac --cycle}"
clipboardfile="${CLIPBOARD:=${XDG_DATA_HOME:-${HOME}/.local/share}/clipboard}"

#^ runtime checks
which notify-send 1>/dev/null 2>&1 || nonotify=t
which dialog 1>/dev/null 2>&1 || nodialog=t
which dmenu 1>/dev/null 2>&1 || nodmenu=t
which fzf 1>/dev/null 2>&1 || nofzf=t
which xclip 1>/dev/null 2>&1 || noxclip=t
which yad 1>/dev/null 2>&1 || noyad=t
which zenity 1>/dev/null 2>&1 || nozenity=t
xset q 1>/dev/null 2>&1 || nox=t

if [ -n "$nox" ]; then
    if [ -n "$nofzf" ]; then exit 1; else alias menucmd="$fzfcmd"; fi
    if [ -n "$nouserclip" ]; then exit 1; clipboard='user'; fi
    if [ -n "$nodialog" ]; then exit 1; else prompt='dialog'; fi
else
    if [ -n "$nodmenu" ]; then exit 1; else alias menucmd="$dmenucmd"; fi
    if [ -n "$noxclip" ]; then clipboard='user'; else clipboard='xclip'; fi

    if [ -n "$noyad" ]; then : ; else prompt='yad'; fi
    if [ -n "$nozenity" ]; then exit 1; else prompt='zenity'; fi
fi
#$

prompt() { #^
    # prompt <string prompt> [bool hidden] -> string
    [ -n "$nonotify" ] || notify-send "sfx" "win95/DA_ERROR.WAV"
    case $prompt in
        dialog)
            if [ -n "$2" ]; then
                dialog --passwordbox "$1" 10 60 3>&1 1>&2 2>&3 3>&1
            else
                dialog --inputbox "$1" 10 60 3>&1 1>&2 2>&3 3>&1
            fi ;;
        zenity)
            if [ -n "$2" ]; then
                zenity --password
            else
                zenity --entry --text="$1"
            fi ;;
        yad) : ;;
    esac
} #$

clipboard() { #^
    # clipboard (yank <string PROMPT>)|put [clipboard|primary|secondary]
    [ -n "$nonotify" ] || notify-send "sfx" "win95/DA_MENUC.WAV"
    case $clipboard in
        user) case $1 in
            yank) printf '%s' "$2" > "$clipboardfile" ;;
            put) cat "$clipboardfile" ;;
        esac ;;
        xclip) case $1 in
            yank) printf '%s' "$2" | eval "xclip -i -selection ${3:-clipboard}" ;;
            put) eval "xclip -o -selection ${3:-clipboard}" ;;
        esac ;;
    esac
} #$

menu(){ #^
    # menu <func. menu> [str. prompt] [bool print_query]
    [ -n "$nonotify" ] || notify-send "sfx" "win95/DA_MENU.WAV"
    case "$nox" in
        t) eval "$1 | menucmd ${2:+--prompt \"$2 \"} ${3:+--print-query}" ;; # sucks
        *)
            if [ -n "$mouse" ]; then
                eval "$(xdotool getmouselocation --shell)"
                eval "$1 | dmenu -i -l 20 -x $X -y $Y -z 200"
            else
                eval "$1 | menucmd ${2:+-p \"$2\"}"
            fi ;;
    esac
} #$

buffer(){ #^
    # buffer <file>
    [ -n "$nonotify" ] || notify-send "sfx" "win95/DA_QUEST.WAV"
    case "$nox" in
        t) eval "${EDITOR:-nano} $1" ;;
        *) eval "${TERMINAL:-xterm} -e ${EDITOR:-nano} $1" ;;
    esac
} #$

dir_contents(){ #^
    # dir_contents <dir>
    find "$1" -type f -print0 |
    xargs --null -n 1 -I {} basename {}
} #$

# vim: fdm=marker fmr=#^,#$
