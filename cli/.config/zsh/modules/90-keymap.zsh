# completion menus
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# custom functions
isfunction _zsh_bookmark_add && bindkey "^[m" _zsh_bookmark_add
isfunction _zsh_bookmarks && bindkey "^['" _zsh_bookmarks
isfunction lfcd && bindkey -s "^F" "lfcd^m"

# misc.
bindkey ' ' magic-space
bindkey '^ ' autosuggest-accept
bindkey '^A' autosuggest-accept
bindkey -M vicmd v edit-command-line
bindkey -s "^Xi" "ii_read.sh^mii_message.sh^m"
bindkey -s "^Xk" "while kill % 2>/dev/null; do : ; done^m"
bindkey -s "^Z" "%-^m"
bindkey -v '^?' backward-delete-char

