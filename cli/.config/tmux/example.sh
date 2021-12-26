#!/bin/sh

tmux -f ${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf start-server

name="default"

if tmux list-sessions -F \#{session_name} | \
    grep "$name" 1>/dev/null 2>&1 ; then
    exit
fi

tmux new-session -d -s "$name" -n "$name" "cd ${HOME}/Downloads && neomutt; $SHELL"
tmux split-window -t "${name}" "$EDITOR $TODO; $SHELL"
tmux split-window -t "${name}" -f -h "newsboat; $SHELL"
tmux split-window -t "${name}" "cd ~/.local/share/ii/servers; $SHELL"
