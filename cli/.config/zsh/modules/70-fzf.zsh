source "${fzfplugins}/completion.zsh" 2>/dev/null
source "${fzfplugins}/key-bindings.zsh" 2>/dev/null

export FZF_CTRL_R_OPTS="--reverse"

if [ -d /var/lib/relocate ]; then
    export FZF_ALT_C_COMMAND="cat /var/lib/relocate/relocated.db"
fi
