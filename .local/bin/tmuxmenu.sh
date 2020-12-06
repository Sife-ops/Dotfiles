#!/bin/sh

alias fzfcmd='fzf -i --cycle --layout=reverse-list'

function ls_ses() {
    this_ses=$(tmux display-message -p '#S')

    if [ "$1" = "active" ]; then
        chosen=$(tmux list-sessions | 
            awk "BEGIN {print \"${this_ses}: (active)\"} {print \$0}" | 
            fzfcmd)
    else
        chosen=$(tmux list-sessions | 
            fzfcmd)
    fi

    echo $chosen | cut -d':' -f1
}

chosen=$(printf "(s)ession\\n(w)indow\\n(p)ane\\n(l)ayout" | 
    fzfcmd --expect=s,w,p,l | 
    sed '2d')

case $chosen in
    # layout
    l) : ;;

    p) chosen=$(printf "(s)plit\\n(k)ill\\n(b)reak\\ns(e)nd" | 
        fzfcmd --expect=s,k,b,e | 
        sed '2d')

        case $chosen in
            s) chosen=$(printf "(h) left\\n(j) down\\n(k) up\\n(l) right" | 
                fzfcmd --expect=h,j,k,l | 
                sed '2d')

                case $chosen in
                    h) tmux split-window -hb -c "#{pane_current_path}" ;;

                    j) tmux split-window -v -c "#{pane_current_path}" ;;

                    k) tmux split-window -vb -c "#{pane_current_path}" ;;

                    l) tmux split-window -h -c "#{pane_current_path}" ;;

                esac ;;

            k) tmux kill-pane ;;

            # break
            b) : ;;

            # send
            e) : ;;

        esac ;;

    s) chosen=$(printf "(a)ttach\\n(k)ill\\n(n)ew\\n(r)ename" | 
        fzfcmd --expect=a,k,n,r | 
        sed '2d')

        case $chosen in
            a) 
                if [ -z $TMUX ]; then
                    tmux attach-session -t $(ls_ses) 2>/dev/null
                else
                    tmux switch-client -t $(ls_ses) 2>/dev/null
                fi ;;

            k) tmux kill-session -t $(ls_ses active) ;;

            n) tmux new-session -d ;;

            r) tmux command-prompt -p "new name: " "rename-session %1" ;;

        esac ;;

    w) chosen=$(printf "(n)ew\\n(k)ill\\n(m)ove" | 
        fzfcmd --expect=n,k,m | 
        sed '2d')

        case $chosen in
            # this, all, other
            k) tmux kill-window ;;

            # move
            m) : ;;

            n) tmux new-window ;;

        esac ;;
esac
