# completion selection menu
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''

# match lower case letters with upper case letters
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # lower case w/ lower/upper case
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # lower/upper case w/ lower/upper case
#zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' # same as last, but only when no case-sensitive match

