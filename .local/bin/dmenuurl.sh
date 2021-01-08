#!/bin/sh
# url action menu

if which checkdeps.sh >/dev/null 2>&1; then
    checkdeps.sh dmenu || exit 1; fi

alias dmenucmd='dmenu -b -i -l 20'
which tsp 1>/dev/null 2>&1 && alias bgcmd='tsp' || alias bgcmd='setsid -f'

msg_help() { echo \
"Usage:
    dmenuurl.sh [URL]"
}

[ -z $1 ] && url="$(xclip -selection clipboard -o)" || url="$1"

base="$(basename "$url")"

chosen=$(echo \
"File: $base
add feed
browser
copy to clipboard
curl
mpv
sxiv
youtube-dl" | dmenucmd -p "action")

case $chosen in
    "add feed") echo $url >> ${HOME}/.config/newsboat/urls ;;
	browser) setsid -f "$BROWSER" "$url" >/dev/null 2>&1 ;;
    "copy to clipboard") echo "$url" > ${CLIPBOARD:-${XDG_DATA_HOME}/clipboard} ;;
    curl) bgcmd curl -LO --output-dir ~/Downloads $url ;;
	mpv) setsid -f mpv -quiet "$url" >/dev/null 2>&1 ;;
    sxiv) tmp=$(mktemp /tmp/sxivXXX) && curl -L $url -o $tmp && setsid -f sxiv $tmp ;;
    youtube-dl) chosen=$(echo \
"automatic
best quality
audio only
audio playlist" | dmenucmd -p "ytdl")

        case $chosen in
            automatic) bgcmd youtube-dl -o ~/Downloads/%\(title\)s.%\(ext\)s $url ;;
            "best quality") bgcmd youtube-dl -f bestvideo+bestaudio -o ~/Downloads/%\(title\)s.%\(ext\)s $url ;;
            "audio only") bgcmd youtube-dl -x --audio-format mp3 -o ~/Downloads/%\(title\)s.%\(ext\)s "$url" ;;
            "audio playlist") bgcmd youtube-dl -i --extract-audio --audio-format mp3 -o ~/Downloads/%\(title\)s.%\(ext\)s "$url" ;;
            *) exit ;;
        esac ;;
    *) exit ;;
esac
