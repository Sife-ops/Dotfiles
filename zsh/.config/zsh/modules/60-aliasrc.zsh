#            _ _
#       __ _| (_) __ _ ___ _ __ ___
#      / _` | | |/ _` / __| '__/ __|
#     | (_| | | | (_| \__ \ | | (__
#    (_)__,_|_|_|\__,_|___/_|  \___|

#^ Coreutils

alias \
    ll='ls -la' \

case "$(uname)" in
    Linux) alias \
        cp="cp -iv" \
        diff="diff --color=auto" \
        grep="grep --color=auto" \
        less='less -i' \
        ll='ls -la --color=auto' \
        ls="ls -ahN --color=auto --group-directories-first" \
        mkdir="mkdir -pv" \
        mv="mv -iv" \
        rm="rm -vI" ;;
esac

#$

#^ Docker

alias \
    dcl='docker container list' \
    dcl='docker container ls -a' \
    di='docker images -a'

#$

#^ Files

alias \
    stc="cd ~/.local/src/st && $EDITOR config.def.h" \
    tc="$EDITOR ~/.dotfiles/cli/.config/tmux/tmux.conf" \
    vc="cd ~/.dotfiles/nvim/.config/nvim && $EDITOR init.lua" \
    xc="$EDITOR ~/.Xresources" \
    zc="cd ~/.dotfiles/zsh/.config/zsh && lfcd"

#$

#^ Git

alias \
    ga='git add' \
    gap='git add -p' \
    gb='git branch' \
    gc='git checkout' \
    gcl='git checkout @{-1}' \
    gcm='git commit -m' \
    gcp='git cherry-pick' \
    gd='git diff' \
    gi="git status --porcelain | grep '^??' | cut -c4- >> .gitignore" \
    gl='git log' \
    glg="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset) %C(bold cyan)(committed: %cD)%C(reset) %C(auto)%d%C(reset)%n''          %C(white)%s%C(reset)%n''          %C(dim white)- %an <%ae> %C(reset) %C(dim white)(committer: %cn <%ce>)%C(reset)'" \
    gm='git merge' \
    gp='git push' \
    gs='git status' \
    gst='git stash'

#$

#^ Systemd

alias \
    ju='journalctl -u' \
    jxe='journalctl -xe' \
    sd='sudo systemctl disable' \
    se='sudo systemctl enable' \
    sr='sudo systemctl restart' \
    ss='sudo systemctl start' \
    sst='sudo systemctl stop'

#$

#^ Tmux

# todo: move to functions.zsh
tmux_config=${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf
tmux-with-name() {
    if [ -z $1 ]; then
        tmux -f $tmux_config
    else
        tmux -f $tmux_config new -s $1
    fi
}

alias \
	t='tmux-with-name' \
	tmux="tmux -f ${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf" \
    ta='tmux attach-session -t' \
    tbl='tmux list-buffers' \
    tbs='tmux set-buffer' \
    td='tmux attach-session -t default' \
    tg='tmux new-session -t' \
    tk='tmux kill-session -t' \
    tl='tmux list-sessions' \
    tn='tmux new-session -d -s' \
	tt="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/default.sh && \\
        tmux attach-session -t default"

#$

#^ Vim

command -v nvim >/dev/null \
    && alias vim="nvim" v="nvim" vimdiff="nvim -d" vd="nvim -d"  \
    || alias v="vim" vimdiff="vim -d" vd="vim -d"

#$

#^ Miscellaneous

alias \
    c='clear' \
    chx='chmod +x' \
    d='dragon-drag-and-drop' \
    f='lfcd' \
    fcl='fc-list : family style | less' \
    fvm='sudo fuser -vm' \
    j='jobs -d' \
    k='kill' \
    ka="killall" \
    myip='dig +short myip.opendns.com @resolver1.opendns.com' \
    p="sudo pacman" \
    pg='pgrep' \
    pk='pkill' \
    r='rangercd'

#$

# vim: fdm=marker fmr=#^,#$

