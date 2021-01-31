#            _ _
#       __ _| (_) __ _ ___ _ __ ___
#      / _` | | |/ _` / __| '__/ __|
#     | (_| | | | (_| \__ \ | | (__
#    (_)__,_|_|_|\__,_|___/_|  \___|

#^----- COMMAND OPTIONS --------------------------------------------------------

alias \
    cp="cp -iv" \
    diff="diff --color=auto" \
    ffmpeg="ffmpeg -hide_banner" \
    grep="grep --color=auto" \
    hl="highlight --out-format=ansi" \
    less='less -i' \
    ls="ls -ahN --color=auto --group-directories-first" \
    mv="mv -iv" \
    mkdir="mkdir -pv" \
    rm="rm -vI"

#$

#^----- ABBREVIATIONS ----------------------------------------------------------

#^ General

alias \
    abook="abook -C ${XDG_CONFIG_HOME:-${HOME}/.config}/abook/abookrc \\
        --datafile ${XDG_DATA_HOME:-${HOME}/.local/share}/addressbook" \
    cal='calcurse' \
    chx='chmod +x' \
    d='dragon-drag-and-drop' \
    f='lfcd' \
    fcl='fc-list : family style | less' \
    fvm='sudo fuser -vm' \
    irssi="irssi --config=${XDG_CONFIG_HOME:-${HOME}/.config}/irssi/config \\
        --home=${XDG_CONFIG_HOME:-${HOME}/.config}/irssi" \
    k='kill' \
    ka="killall" \
    ll='ls -la --color=auto' \
    myip='dig +short myip.opendns.com @resolver1.opendns.com' \
    n='nnncd' \
    nb='newsboat' \
    offlineimap="offlineimap -c \\
        ${XDG_CONFIG_HOME:-$HOME/.config}/offlineimap/offlineimaprc" \
    p="sudo pacman" \
    pg='pgrep' \
    pk='pkill' \
    r='rangercd' \
    rtorrent='rtorrent -n -o import=~/.config/rtorrent/rtorrent.rc' \
	sdn="sudo shutdown -h now" \
    so="source {${XDG_CONFIG_HOME:-${HOME}/.config}/aliasrc,${ZDOTDIR}/.zshrc}" \
    so="source ~/.zprofile; source ${ZDOTDIR}/.zshrc" \
    tp='trash-put' \
    xo='xdg-open' \
    xr='xrdb ~/.Xresources' \
    z="zathura"

#$

#^ Emacs

systemctl --quiet --user is-active emacs.service >/dev/null \
    && alias e='emacsclient' \
    || alias e='emacs'

#$

#^ Git

alias \
    ga='git add' \
    gap='git add -p' \
    gau='git add -u' \
    gb='git branch' \
    gch='git checkout' \
    gcm='git commit -m' \
    gdh='git diff HEAD | less' \
    gi="git status --porcelain | grep '^??' | cut -c4- >> .gitignore" \
    gl='git ls-tree -r master --name-only | less' \
    glu='git ls-files --others --exclude-standard | less' \
    glua='git ls-files --others | less' \
    gp='git push -u origin main' \
    grh='git reset --hard' \
    grl='git rev-list --pretty=oneline --abbrev-commit HEAD | less' \
    grm='git rm -r --cached' \
    gs='git status'

#$

#^ Mutt

command -v neomutt >/dev/null \
    && alias m="cd ~/Downloads && neomutt" mutt="cd ~/Downloads && neomutt" \
    || alias m="cd ~/Downloads && mutt" mutt="cd ~/Downloads && mutt"

#$

#^ Tmux

alias \
	t="tmux -f ${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf" \
    ta='tmux attach-session -t' \
    tg='tmux new-session -t' \
    tk='tmux kill-session -t' \
    tl='tmux list-sessions' \
	tmux="tmux -f ${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"

#$

#^ Vim

command -v nvim >/dev/null \
    && alias vim="nvim" v="nvim" vimdiff="nvim -d" vd="nvim -d"  \
    || alias v="vim" vimdiff="vim -d" vd="vim -d"

#$

#$

# vim: fdm=marker fmr=#^,#$
