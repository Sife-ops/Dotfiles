#!/bin/sh
# manage clipboards

if which checkdeps.sh >/dev/null 2>&1; then
    checkdeps.sh xclip fzf || exit 1; fi

alias fzfcmd='fzf --no-sort --layout=reverse-list'

function translateChosen(){
    case $1 in
        p) echo "primary" ;;
        s) echo "secondary" ;;
        c) echo "clipboard" ;;
        u) echo "user" ;;
    esac
}

chosen_a=$(echo \
"=*SOURCE*=
(p)rimary: $(xclip -o -selection primary | head -n1)
(s)econdary: $(xclip -o -selection secondary | head -n1)
(c)lipboard: $(xclip -o -selection clipboard | head -n1)
(u)ser: $(head -n1 ${CLIPBOARD:-${HOME}/.local/share/clipboard})" |
    fzfcmd --expect=p,s,c,u |
    sed '2d')

chosen_b=$(echo \
"=*TARGET*=
(p)rimary
(s)econdary
(c)lipboard
(u)ser" |
    fzfcmd --expect=p,s,c,u |
    sed '2d')

chosen_a=$(translateChosen $chosen_a)
chosen_b=$(translateChosen $chosen_b)

case $chosen_a in
    user) cmd_a="cat ${CLIPBOARD:-${XDG_DATA_HOME}/clipboard} " ;;
    *) cmd_a="xclip -o -selection $chosen_a " ;;
esac

case $chosen_b in
    user) cmd_b="> ${CLIPBOARD:-${XDG_DATA_HOME}/clipboard}" ;;
    *) cmd_b="| xclip -i -selection $chosen_b" ;;
esac

eval "$cmd_a $cmd_b"
