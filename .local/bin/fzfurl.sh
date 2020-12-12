#!/bin/sh
# url action menu

if which checkdeps.sh >/dev/null 2>&1; then
    checkdeps.sh fzf || exit 1; fi

alias fzfcmd='fzf --no-sort --layout=reverse-list'
which tsp 1>/dev/null 2>&1 && alias bgcmd='tsp' || alias bgcmd='setsid -f'

msg_help() { echo \
"Usage:
    fzfurl.sh [URL]"
}

[ -z $1 ] && url="$(xclip -selection clipboard -o)" || url="$1"

base="$(basename "$url")"

chosen=$(echo \
"File: $base
(a)dd feed
(b)rowser
(c)opy to clipboard
c(u)rl
(m)pv
(s)xiv
(y)outube-dl" | fzfcmd --expect=a,b,c,u,m,s,y | sed '2d')

case $chosen in
    a) echo $url >> ${HOME}/newsboat/urls ;;
    b) setsid -f $BROWSER $url ;;
    c) echo "$url" | xclip -selection clipboard ;;
    u) bgcmd curl -LO --output-dir ~/Downloads $url ;;
    m) setsid -f mpv -quiet "$url" >/dev/null 2>&1 ;;
    s) tmp=$(mktemp /tmp/sxivXXX) && curl -L $url -o $tmp && setsid -f sxiv $tmp ;;
    y) chosen=$(echo \
"(a)utomatic
(b)est quality
audio (o)nly
audio (p)laylist" | fzfcmd --expect=a,b,o,p | sed '2d')

        case $chosen in
            a) bgcmd youtube-dl -o ~/Downloads/%\(title\)s.%\(ext\)s $url ;;
            b) bgcmd youtube-dl -f bestvideo+bestaudio -o ~/Downloads/%\(title\)s.%\(ext\)s $url ;;
            o) bgcmd youtube-dl -x --audio-format mp3 -o ~/Downloads/%\(title\)s.%\(ext\)s "$url" ;;
            p) bgcmd youtube-dl -i --extract-audio --audio-format mp3 -o ~/Downloads/%\(title\)s.%\(ext\)s "$url" ;;
        esac ;;
esac
