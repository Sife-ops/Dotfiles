if [ -f "${zshplugins}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ]; then
    source "${zshplugins}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" 2>/dev/null
else
    source "${zshplugins}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" 2>/dev/null
fi
