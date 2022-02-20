#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

export PATH="${PATH}:${HOME}/.local/bin"

export EDITOR=vim

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

source "/usr/share/fzf/completion.bash" 2>/dev/null
source "/usr/share/fzf/key-bindings.bash" 2>/dev/null

export FZF_CTRL_R_OPTS="--reverse"
