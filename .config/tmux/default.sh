#!/bin/sh

tmux -f ${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf start-server

session="default"
win0="default"

tmux new-session -d -s "$session" -n "$win0"

tmux split-window -t "${session}:${win0}.0" -h
tmux split-window -t "${session}:${win0}.0" -v
tmux split-window -t "${session}:${win0}.2" -v

# -------------
# |  0  |  2  |
# -------------
# |  1  |  3  |
# -------------

tmux send-keys -t "${session}:${win0}.0" "neomutt" C-m
tmux send-keys -t "${session}:${win0}.1" "newsboat" C-m
tmux send-keys -t "${session}:${win0}.2" "irssi" C-m
