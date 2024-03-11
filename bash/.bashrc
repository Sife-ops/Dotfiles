#  /\/|  ___               _              
# |/\/  / / |__   __ _ ___| |__  _ __ ___ 
#      / /| '_ \ / _` / __| '_ \| '__/ __|
#     / /_| |_) | (_| \__ \ | | | | | (__ 
#    /_/(_)_.__/ \__,_|___/_| |_|_|  \___|

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

export HISTSIZE=9999999

export PATH="${PATH}:${HOME}/go/bin"
export PATH="${PATH}:${HOME}/.local/bin"
export PATH="${PATH}:${HOME}/.local/share/nvim/mason/bin"

which nvim >/dev/null 2>&1 \
	&& editor="nvim" \
	|| editor="vim"
export EDITOR="$editor"
export VISUAL="$editor"

set -o vi

lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}

alias f='lfcd'
alias ls='ls --color=auto'

source ~/.bash_ext
