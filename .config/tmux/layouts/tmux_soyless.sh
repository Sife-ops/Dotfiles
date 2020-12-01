#!/bin/sh
# Setup a work space called `dashboard`

session="soyless"
tmux start-server
tmux new-session -d -s $session -n "home"
tmux send-keys "cd /usr/share/nginx/soyless.tst/html && nvim index.html" C-m
tmux splitw -h
tmux send-keys "cd /usr/share/nginx/soyless.tst/html && nvim styles.css" C-m
tmux splitw -f -v -p 20
tmux attach-session -t $session
