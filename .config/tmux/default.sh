#!/bin/sh

tmux -f ${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf start-server

name="default"

if tmux list-sessions -F \#{session_name} | \
    grep "$name" 1>/dev/null 2>&1 ; then
    exit
fi

tmux new-session -d -s "$name" -n "$name"

tmux split-window -t "${name}:0.0" -v
tmux split-window -t "${name}:0.0" -v
tmux select-layout -E -t "${name}:0"
tmux split-window -t "${name}:0.0" -h
tmux split-window -t "${name}:0.2" -h

# -------------------------
# |     0     |     1     |
# -------------------------
# |     2     |     3     |
# -------------------------
# |           4           |
# -------------------------

tmux send-keys -t "${name}:0.0" "cd ~/Downloads && neomutt" C-m
tmux send-keys -t "${name}:0.1" "v $TODO" C-m
tmux send-keys -t "${name}:0.2" "newsboat" C-m
# tmux send-keys -t "${name}:0.3" "command emacs --daemon && emacsclient -nw" C-m
tmux send-keys -t "${name}:0.3" "cd ~/.local/share/ii && f" C-m
tmux send-keys -t "${name}:0.4" "pulsemixer" C-m
