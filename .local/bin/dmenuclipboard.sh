#!/bin/sh
# manage clipboards

if which checkdeps.sh >/dev/null 2>&1; then
    checkdeps.sh xclip dmenu || exit 1; fi

alias dmenucmd='dmenu -b -i -l 20'

chosen_a=$(echo \
"primary: $(xclip -o -selection primary | head -n1)
secondary: $(xclip -o -selection secondary | head -n1)
clipboard: $(xclip -o -selection clipboard | head -n1)
user: $(head -n1 ${CLIPBOARD:-${HOME}/.local/share/clipboard})" |
    dmenucmd -p "source" |
    cut -d':' -f1)

chosen_b=$(echo \
"primary
secondary
clipboard
user" | dmenucmd -p "target")

case $chosen_a in
    user) cmd_a="cat ${CLIPBOARD:-${XDG_DATA_HOME}/clipboard} " ;;
    *) cmd_a="xclip -o -selection $chosen_a " ;;
esac

case $chosen_b in
    user) cmd_b="> ${CLIPBOARD:-${XDG_DATA_HOME}/clipboard}" ;;
    *) cmd_b="| xclip -i -selection $chosen_b" ;;
esac

eval "$cmd_a $cmd_b"
