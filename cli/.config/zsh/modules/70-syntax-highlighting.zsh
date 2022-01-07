if ! source "${zshplugins}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" 2>/dev/null; then
    if [ $(uname) = "Darwin" ]; then
        source "${zshplugins}/zsh-syntax-highlighting/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" 2>/dev/null
    else
        source "${zshplugins}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" 2>/dev/null
    fi
fi
