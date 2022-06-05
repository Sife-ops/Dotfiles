# completion
autoload -U compinit && compinit
_comp_options+=(globdots)

# command editor
autoload -U edit-command-line
zle -N edit-command-line

# prompt
autoload -U promptinit && promptinit
autoload -U colors && colors

