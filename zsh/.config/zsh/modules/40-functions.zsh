#   __                  _   _
#  / _|_   _ _ __   ___| |_(_) ___  _ __  ___
# | |_| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
# |  _| |_| | | | | (__| |_| | (_) | | | \__ \
# |_|  \__,_|_| |_|\___|\__|_|\___/|_| |_|___/

#^ Special

chpwd () { #^
    emulate -L zsh

    # Auto ls
    if which lsd 1>/dev/null 2>&1; then
        lsd -a
    else
        case "$(uname)" in
            Linux) ls -ahN --color=auto --group-directories-first ;;
            *) ls ;;
        esac
    fi

    # Use zshconfig.zsh
    [ -e "./zshconfig.zsh" ] && source "./zshconfig.zsh"

} #$

preexec () { #^

    # Use beam shape cursor on startup and for each new prompt.
    echo -ne '\e[5 q'

} #$

#$

#^ Widgets

zle-keymap-select () { #^
    # Change cursor shape for different vi modes.
    if [[ ${KEYMAP} == vicmd ]] ||
        [[ $1 = 'block' ]]; then
        echo -ne '\e[1 q'
    elif [[ ${KEYMAP} == main ]] ||
        [[ ${KEYMAP} == viins ]] ||
        [[ ${KEYMAP} = '' ]] ||
        [[ $1 = 'beam' ]]; then
        echo -ne '\e[5 q'
    fi
}
zle -N zle-keymap-select #$

zle-line-init () { #^
    # Initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    zle -K viins
    echo -ne "\e[5 q"
}
zle -N zle-line-init #$

#$

#^ Docker

dka(){ #^
    docker container kill $(docker ps -q)
    docker rm $(docker ps -a -f status=exited -q)
} #$

#^
ds(){
    docker exec -it $1 sh
}
#$

#$

#^ Git

gct() { #^
    git branch -D test 2>/dev/null
    git checkout -b test
} #$

fzf-git-branch() { #^
    git rev-parse HEAD > /dev/null 2>&1 || return

    git branch --color=always --all --sort=-committerdate |
        grep -v HEAD |
        fzf --height 50% --ansi --no-multi --preview-window right:65% \
            --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
        sed "s/.* //"
} #$

#$

#^ Misc.

demonize () { #^
    # node convenience function
    while inotifywait --quiet "./$1"; do
        clear
        ${2:-node} "./$1"
    done
} #$

ex () { #^
    # Extracts archives.
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2|*.tbz2) tar xvjf "$1" ;;
            *.tar.xz) tar -xf "$1" ;;
            *.tar.gz|*.tgz) tar xvzf "$1" ;;
            *.lzma) unlzma "$1" ;;
            *.bz2) bunzip2 "$1" ;;
            *.rar) unrar x -ad "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar xvf "$1" ;;
            *.zip) unzip "$1" ;;
            *.Z) uncompress "$1" ;;
            *.7z) 7z x "$1" ;;
            *.xz) unxz "$1" ;;
            *.exe) cabextract "$1" ;;
            *) printf "extract: '%s' - unknown archive method\\n" "$1" ;;
        esac
    else
        printf "File \"%s\" not found.\\n" "$1"
    fi
} #$

ggf () { #^
    # Wrapper for git.
    git commit -p && git push origin "$(git rev-parse --abbrev-ref HEAD)"
} #$

isfunction () { #^
    # test whether function is defined
    if type $1 | grep -q 'is a shell function' 2>/dev/null; then
        true
    else
        false
    fi
} #$

lfcd () { #^
    # Configure lf to cd on quit
    emulate -L zsh
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
                print -s "cd $dir"
            fi
        fi
    fi
} #$

rangercd () { #^
    temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
    ranger --choosedir="$temp_file" -- "${@:-$PWD}"
    if chosen_dir="$(cat -- "$temp_file")" && [ -n "$chosen_dir" ] && [ "$chosen_dir" != "$PWD" ]; then
        cd -- "$chosen_dir"
    fi
    rm -f -- "$temp_file"
} #$

rn () { #^
    rittle --prefix wg --project $1 new | xargs code
} #$

#$

# vim: ft=sh fdm=marker fmr=#^,#$
