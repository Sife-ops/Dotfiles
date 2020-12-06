!/bin/sh
# Setup a work space called `dashboard`

session="default"
tmux start-server
tmux new-session -d -s $session -n "default"
tmux send-keys "calcurse" C-m
tmux splitw -h
tmux send-keys "vim ~/Documents/vimwiki/index.wiki" C-m
tmux selectp -t 0
tmux splitw -v
tmux send-keys "mutt" C-m
tmux attach-session -t $session
