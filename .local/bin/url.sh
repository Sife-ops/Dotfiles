#!/bin/sh
# general purpose url handler
# todo:
# finish setsid/tmux bg functions
# test without notify-send present
# research alternate terminals

. menu.sh

#^ runtime check
download_dir="${XDG_DOWNLOAD_DIR:-${HOME}/Downloads}"
[ ! -d "$download_dir" ] && mkdir -p "$download_dir"

which curl 1>/dev/null 2>&1 || nocurl=t
which mpv 1>/dev/null 2>&1 || nompv=t
which setsid 1>/dev/null 2>&1 || nosetsid=t
which sxiv 1>/dev/null 2>&1 || nosxiv=t
which tmux 1>/dev/null 2>&1 || notmux=t
which tsp 1>/dev/null 2>&1 || notsp=t
which youtube-dl 1>/dev/null 2>&1 || noytdl=t

[ -e "${BOOKMARKS:=${XDG_DATA_HOME}/bookmarks}" ] || nobookmarks=t
[ -e "${FEEDS:=${XDG_CONFIG_HOME}/newsboat/urls}" ] || nofeeds=t

which "${BROWSER:=firefox}" 1>/dev/null 2>&1 || nobrowser=t
which "${TERMINAL:=xfce4-terminal}" 1>/dev/null 2>&1 || noterm=t
case "$TERMINAL" in
    alacritty) : ;; # todo
    st) termcmd='st -c dd -e sh -c' ;;
    urxvt) : ;; # todo
    xfce4-terminal) : ;; # todo
    xterm) : ;; # todo
    "") : ;;
    *) : ;;
esac
#$

#^ input
if [ -n "$1" ]; then
    url="$1"
else
    url="$(clipboard put)"
fi
if [ -n "$url" ]; then
    urlbase="$(basename "$url")"
else
    exit 1
fi
#$

#^ functions
#^ lists
main_list(){ #^
printf 'File: %s\n' "$urlbase"
printf 'add feed\n'
printf 'add bookmark\n'
[ -z "$nobrowser" ] && printf 'browser\n'
[ -z "$nox" ] && printf 'copy to clipboard\n'
[ -z "$nocurl" ] && printf 'curl\n'
[ -z "$nox" ] && [ -z "$nompv" ] && printf 'mpv\n'
[ -z "$nox" ] && [ -z "$nosxiv" ] && printf 'sxiv\n'
[ -z "$noytdl" ] && printf 'youtube-dl\n'
} #$

ytdl_list(){ #^
echo "automatic
best quality
audio only
audio playlist"
} #$

bg_list(){ #^
[ -z "$notsp" ] && printf "task spooler\n"
[ -z "$nosetsid" ] && printf "setsid\n"
[ -z "$nox" ] && [ -z "$noterm" ] && printf "terminal\n"
[ -z "$notmux" ] && printf "tmux\n"
} #$ #$

bg_with(){ #^
    # bg_with <bg_type> <command>
    cd "$download_dir" || kill 0
    case "$1" in
        tsp) notify-send "task spooler" "Queuing $urlbase... ⏳"
             tspid=$(eval tsp "$2")
             tsp -D "$tspid" notify-send "task spooler" "$urlbase is finished downloading. 👍" ;;
        setsid) : ;;
        term) notify-send "terminal" "Queuing $urlbase... ⏳"
              eval "$termcmd \"$2; notify-send 'terminal' '$urlbase is finished downloading. 👍'\"" ;;
        tmux) : ;;
    esac
} #$

bg_menu(){ #^
    # bg_menu <command>
    chosen=$(menu bg_list "background") # no prompt word splitting
    case "$chosen" in
        "task spooler") bg_with tsp "$1" ;;
        setsid) bg_with setsid "$1" ;;
        terminal) bg_with term "$1" ;;
        tmux) bg_with tmux "$1" ;;
        "") kill 0 ;;
        *) kill 0 ;;
    esac
} #$

ytdl_menu(){ #^
    chosen=$(menu ytdl_list "youtube-dl")
    case "$chosen" in
        automatic) bg_menu "youtube-dl $url" ;;
        "best quality") bg_menu "youtube-dl -f bestvideo+bestaudio $url" ;;
        "audio only") bg_menu "youtube-dl -x --audio-format mp3 $url" ;;
        "audio playlist") bg_menu "youtube-dl -i --extract-audio --audio-format mp3 $url" ;;
        "") kill 0 ;;
        *) kill 0 ;;
    esac
} #$ #$ #$

#^ main menu
chosen=$(menu main_list "action")
case "$chosen" in
    "add feed") echo "$url" >> "$FEEDS" ;;
    "add bookmark") echo "$url" >> "$BOOKMARK" ;;
	browser) setsid -f "$BROWSER" "$url" 1>/dev/null 2>&1 ;; # change to & disown?
    "copy to clipboard") echo "$url" > "${CLIPBOARD:-${XDG_DATA_HOME}/clipboard}" ;;
    curl) bg_menu "curl -LO $url" ;;
	mpv) setsid -f mpv -quiet "$url" 1>/dev/null 2>&1 ;; # change to & disown?
    sxiv) tmp=$(mktemp /tmp/sxivXXX) && curl -L "$url" -o "$tmp" && setsid -f sxiv "$tmp" ;;
    youtube-dl) ytdl_menu ;;
    "") exit 1 ;;
    *) exit 1 ;;
esac
#$

# vim: fdm=marker fmr=#^,#$
