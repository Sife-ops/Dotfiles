#!/bin/sh

# todo
# bash alias weirdness
# follow flag option

alias fzfcmd='fzf --no-sort --layout=reverse-list'

chosen=$(echo -e \
"(d)esktop
(l)ayout
(m)onitor
(n)ode" | fzfcmd --expect=d,l,m,n | sed '2d')

case $chosen in
    d) cmd="bspc desktop" ;;
    l) cmd="bsp-layout" ;;
    m) cmd="bspc monitor" ;;
    n) cmd="bspc node"
        chosen=$(echo -e \
"(n)ODE_SEL
(f)ocus" | fzfcmd --expect=n,f | sed '2d')
        case $chosen in
            n) cmd="$cmd $(fzfnode.sh)" ;;
            f) ;; *) exit 1 ;;
        esac ;;
    *) exit 1 ;;
esac

