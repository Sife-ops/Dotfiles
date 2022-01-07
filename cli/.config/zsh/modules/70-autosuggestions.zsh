if [ $(uname) = "Darwin" ]; then
    source "${zshplugins}/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh" 2>/dev/null
else
    source "${zshplugins}/zsh-autosuggestions/zsh-autosuggestions.zsh" 2>/dev/null
fi

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10"
