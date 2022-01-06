if [ -f "${zshplugins}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ]; then
    source "${zshplugins}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" 2>/dev/null
else
    # todo: fix retarded OS detection
    # source "${zshplugins}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" 2>/dev/null
    source "${zshplugins}/zsh-syntax-highlighting/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" 2>/dev/null
fi
