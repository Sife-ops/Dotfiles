#!/bin/sh

clipboard="${CLIPBOARD:-${XDG_DATA_HOME:-${HOME}/.local/share}/clipboard}"
[ -d "$clipboard" ] || mkdir -p "$clipboard"

alias dmenucmd="${DMENU_CMD:-dmenu -b -i -l 20}"
alias fzfcmd="${FZF_CMD:-fzf --tac --cycle}"

nox="${MENU_NOX}"
case "$nox" in
    "") which dmenu 1>/dev/null || exit 1
        which yad 1>/dev/null || exit 1 ;;
    *) which fzf 1>/dev/null || exit 1
       which dialog 1>/dev/null || exit 1 ;;
esac

choose(){
    case "$nox" in
        "") chosen="$(echo "$1" | dmenucmd ${2:+-p "$2"})" ;;
        *) chosen="$(echo "$1" | fzfcmd ${2:+--prompt "$2 "})" ;;
    esac
}

prompt() {
    # prompt <string prompt> [bool password] -> string
    case "$nox" in
        "")
            if [ -n "$2" ]; then
                yad --text-align=center --text="$1" --entry --hide-text
            else
                yad --text-align=center --text="$1" --entry
            fi ;;
        *)
            if [ -n "$2" ]; then
                dialog --passwordbox "$1" 10 60 3>&1 1>&2 2>&3 3>&1
            else
                dialog --inputbox "$1" 10 60 3>&1 1>&2 2>&3 3>&1
            fi ;;
    esac
}

clipboard() {
    # clipboard yank <string> [clipboard|primary|secondary]
    # clipboard put [clipboard|primary|secondary]
    case "$nox" in
        "") case $1 in
            yank) printf '%s' "$2" | xclip -i -selection ${3:-clipboard} 2>/dev/null ;;
            put) xclip -o -selection ${2:-clipboard} 2>/dev/null ;;
        esac ;;
        *) case $1 in
            yank) case "$3" in
                    clipboard) printf '%s' "$2" > "${clipboard}/00" ;;
                    primary) printf '%s' "$2" > "${clipboard}/01" ;;
                    secondary) printf '%s' "$2" > "${clipboard}/02" ;;
                    "") printf '%s' "$2" > "${clipboard}/00" ;;
                esac ;;
            put) case "$2" in
                    clipboard) cat "${clipboard}/00" ;;
                    primary) cat "${clipboard}/01" ;;
                    secondary) cat "${clipboard}/02" ;;
                    "") cat "${clipboard}/00" ;;
                esac ;;
        esac ;;
    esac
}

buffer(){
    # buffer <file>
    case "$nox" in
        "") ${TERMINAL:-xterm} -e ${EDITOR:-nano} $1 ;;
        *) ${EDITOR:-nano} $1 ;;
    esac
}

dir_contents(){
    # dir_contents <dir>
    find "$1" -type f -print0 |
    xargs --null -I {} basename {}
}
