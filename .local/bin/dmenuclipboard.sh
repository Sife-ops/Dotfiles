#!/bin/sh
# manage clipboards

alias dmenucmd='dmenu -b -i -l 20'

chosen_a=$(echo \
"primary
secondary
clipboard
user" | dmenucmd -p "source")

chosen_b=$(echo \
"primary
secondary
clipboard
user" | dmenucmd -p "target")

case $chosen_a in
    user) asdf="cat ${CLIPBOARD:-${XDG_DATA_HOME}/clipboard} " ;;
    *) asdf="xclip -o -selection $chosen_a " ;;
esac

case $chosen_b in
    user) fdsa="> ${CLIPBOARD:-${XDG_DATA_HOME}/clipboard}" ;;
    *) fdsa="| xclip -i -selection $chosen_b" ;;
esac

eval "$asdf $fdsa"
