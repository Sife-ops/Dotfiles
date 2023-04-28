if status is-interactive
	fish_vi_key_bindings

	alias t="tmux"
	alias ta="tmux attach-session -t"
	alias tg="tmux new-session -t"
	alias tl="tmux list-sessions"
	alias v=$EDITOR
end
