#!/bin/sh
# dmenu url handler
# todo:
# setsid option
# write functions for all options

#^ setup
if which checkdeps.sh 1>/dev/null 2>&1; then
    checkdeps.sh dmenu notify-send || exit 1; fi

msg_help(){ echo \
"Usage:
    dmenuurl.sh [URL]"
}

download_dir="${XDG_DOWNLOAD_DIR:-$HOME/Downloads}"

if which tsp 1>/dev/null; then
    bgcmd='tsp'
elif which st 1>/dev/null; then
    bgcmd='st'
else
    exit 1
fi

alias dmenucmd='dmenu -b -i -l 20'
alias stcmd='st -c dd -e sh -c'
#$

#^ input
if [ -n "$1" ]; then
    url="$1"
else
    url="$(xclip -o -selection clipboard)"
fi

if [ "$url" = "" ]; then
    exit 1
else
    urlbase="$(basename "$url")"
fi
#$

curl_(){ #^
    url="$1"
    base=$(basename "$url")

    case "$bgcmd" in
        st) stcmd "notify-send 'task spooler' 'Queuing $base... ⏳';
            curl -LO --output-dir $download_dir $url;
            notify-send 'task spooler' '$base is finished downloading. 👍'" ;;
            # exec zsh" ;;
        tsp) notify-send "task spooler" "Queuing $base... ⏳"
             tspid=$(tsp curl -LO --output-dir "$download_dir" "$url")
             tsp -D "$tspid" notify-send "task spooler" "$base is finished downloading. 👍" ;;
    esac
} #$

ytdl(){ #^
    if [ -z "$2" ]; then
        url="$1"
        opt=""
    else
        url="$1"
        shift
        opt="$*"
    fi
    base=$(basename "$url")

    case "$bgcmd" in
        st) stcmd "notify-send 'task spooler' 'Queuing $base... ⏳';
            youtube-dl $opt -o $download_dir/%\(title\)s.%\(ext\)s $url;
            notify-send 'task spooler' '$base is finished downloading. 👍'" ;;
            # exec zsh" ;;
        tsp) notify-send "task spooler" "Queuing $base... ⏳"
             tspid=$(eval tsp youtube-dl "$opt" -o "$download_dir"/%\\\(title\\\)s.%\\\(ext\\\)s "$url")
             tsp -D "$tspid" notify-send "task spooler" "$base is finished downloading. 👍" ;;
    esac
} #$

main_menu(){ #^
echo "File: $urlbase
add feed
browser
copy to clipboard
curl
mpv
sxiv
youtube-dl"
} #$

ytdl_menu(){ #^
echo "automatic
best quality
audio only
audio playlist"
} #$

#^ main
chosen=$(main_menu | dmenucmd -p "action")
case "$chosen" in
    "add feed") echo "$url" >> "${HOME}"/.config/newsboat/urls ;;
	browser) setsid -f "$BROWSER" "$url" 1>/dev/null 2>&1 ;;
    "copy to clipboard") echo "$url" > "${CLIPBOARD:-${XDG_DATA_HOME}/clipboard}" ;;
    curl) curl_ "$url" ;;
	mpv) setsid -f mpv -quiet "$url" 1>/dev/null 2>&1 ;;
    sxiv) tmp=$(mktemp /tmp/sxivXXX) && curl -L "$url" -o "$tmp" && setsid -f sxiv "$tmp" ;;
    youtube-dl) chosen=$(ytdl_menu | dmenucmd -p "ytdl")
        case "$chosen" in
            automatic) ytdl "$url" ;;
            "best quality") ytdl "$url" -f bestvideo+bestaudio ;;
            "audio only") ytdl "$url" -x --audio-format mp3 ;;
            "audio playlist") ytdl "$url" -i --extract-audio --audio-format mp3 ;;
            "") exit 1 ;;
            *) exit 1 ;;
        esac ;;
    "") exit 1 ;;
    *) exit 1 ;;
esac
#$

# vim: fdm=marker fmr=#^,#$
