#!/bin/sh
# general purpose url handler
# todo:
# test without notify-send present
# test nox

. menu.sh

downloads="${DOWNLOADS:-${XDG_DOWNLOAD_DIR:-${HOME}/Downloads}}"
[ -d "$downloads" ] || mkdir -p "$downloads"
bookmarks="${BOOKMARKS:-${XDG_DATA_HOME:-${HOME}/.local/share}/bookmarks}"
[ -f "$bookmarks" ] || nobookmarks=t
feeds="${FEEDS:-${XDG_CONFIG_HOME:-${HOME}/.config}/newsboat/urls}"
[ -f "$feeds" ] || nofeeds=t
wallpaper="${WALLPAPER:-${XDG_DATA_HOME:-${HOME}/.local/share}/wallpaper}"
wallpapers="${WALLPAPERS:-${XDG_DATA_HOME:-${HOME}/.local/share}/wallpapers}"

which "${BROWSER:=firefox}" 1>/dev/null 2>&1 || nobrowser=t
which "${TERMINAL:=xterm}" 1>/dev/null 2>&1 || noterm=t
case "$TERMINAL" in
    alacritty) termcmd='alacritty --class dd -e sh -c' ;; # todo
    st) termcmd='st -c dd -e sh -c' ;;
    urxvt) termcmd='urxvt -name dd -e sh -c' ;; # todo
    xfce4-terminal) : ;; # todo
    xterm) termcmd='xterm -class dd -e sh -c' ;; # todo
    "") noterm=t ;;
    *) noterm=t ;;
esac

which curl 1>/dev/null 2>&1 || nocurl=t
which mpv 1>/dev/null 2>&1 || nompv=t
which setsid 1>/dev/null 2>&1 || nosetsid=t
which sxiv 1>/dev/null 2>&1 || nosxiv=t
which tmux 1>/dev/null 2>&1 || notmux=t
which tsp 1>/dev/null 2>&1 || notsp=t
which youtube-dl 1>/dev/null 2>&1 || noytdl=t
which xwallpaper 1>/dev/null 2>&1 || noxwallpaper=t

while getopts "ms" o; do
    case "${o}" in
        m) mouse=t ;;
        s) sound=t ;;
        *) printf "Invalid option: -%s\n" "$o" ;;
    esac
done

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

# wtf?
main_list="File: $urlbase
$([ -z "$nofeeds" ] && printf 'add feed')
$([ -z "$nobookmarks" ] && printf 'add bookmark')
$([ -z "$nobrowser" ] && printf 'browser')
$(printf 'copy to clipboard')
$([ -z "$nocurl" ] && printf 'curl')
$([ -z "$nox" ] && [ -z "$nompv" ] && printf 'mpv')
$([ -z "$nox" ] && [ -z "$nosxiv" ] && printf 'sxiv')
$([ -z "$noytdl" ] && printf 'youtube-dl')
$([ -z "$noxwallpaper" ] && printf 'set wallpaper')"
main_list="$(echo "$main_list" | sed '/^$/d')"

browser_list="$(printf '$BROWSER')
$(which brave 1>/dev/null 2>&1 && printf 'brave')
$(which chromium 1>/dev/null 2>&1 && printf 'chromium')
$(which firefox 1>/dev/null 2>&1 && printf 'firefox')
$(which icecat 1>/dev/null 2>&1 && printf 'icecat')
$(which librewolf 1>/dev/null 2>&1 && printf 'librewolf')
$(which qutebrowser 1>/dev/null 2>&1 && printf 'qutebrowser')"
browser_list="$(echo "$browser_list" | sed '/^$/d')"

bg_list="$([ -z "$notsp" ] && printf "task spooler")
$([ -z "$nosetsid" ] && printf "setsid")
$([ -z "$nox" ] && [ -z "$noterm" ] && printf "terminal")
$([ -z "$notmux" ] && printf "tmux")"
bg_list="$(echo "$bg_list" | sed '/^$/d')"

ytdl_list='automatic
best quality
audio only
audio playlist'

bg_with(){
    # bg_with <bg_type> <command>
    cd "$downloads" || kill 0
    case "$1" in
        tsp) notify-send "task spooler" "Queuing $urlbase... ⏳"
             tspid=$(eval tsp "$2")
             tsp -D "$tspid" notify-send "task spooler" "$urlbase is finished downloading. 👍" ;;
        setsid) : ;;
        term) notify-send "terminal" "Queuing $urlbase... ⏳"
              eval "$termcmd \"$2; notify-send 'terminal' '$urlbase is finished downloading. 👍'\"" ;;
        tmux) : ;;
    esac
}

bg_menu(){
    # bg_menu <command>
    choose "$bg_list" "background with"
    case "$chosen" in
        "task spooler") bg_with tsp "$1" ;;
        setsid) bg_with setsid "$1" ;;
        terminal) bg_with term "$1" ;;
        tmux) bg_with tmux "$1" ;;
        "") kill 0 ;;
        *) kill 0 ;;
    esac
}

browser_menu() {
    choose "$browser_list" "browser"
    setsid -f $chosen $url
}

ytdl_menu(){
    choose "$ytdl_list" "youtube-dl"
    case "$chosen" in
        automatic) bg_menu "youtube-dl $url" ;;
        "best quality") bg_menu "youtube-dl -f bestvideo+bestaudio $url" ;;
        "audio only") bg_menu "youtube-dl -x --audio-format mp3 $url" ;;
        "audio playlist") bg_menu "youtube-dl -i --extract-audio --audio-format mp3 $url" ;;
        "") kill 0 ;;
        *) kill 0 ;;
    esac
}

choose "$main_list" "action"
case "$chosen" in
    "add feed") echo "$url" >> "$feeds" ;;
    "add bookmark") echo "$url" >> "$bookmarks" ;;
    browser) browser_menu ;;
    "copy to clipboard") clipboard yank "$url" ;;
    curl) bg_menu "curl -LO $url" ;;
    mpv) setsid -f mpv -quiet "$url" 1>/dev/null 2>&1 ;; # change to & disown?
    sxiv) tmp=$(mktemp /tmp/sxivXXX)
        curl -L "$url" -o "$tmp" && setsid -f sxiv "$tmp" ;;
    youtube-dl) ytdl_menu ;;
    "set wallpaper")
        mkdir -p "$wallpapers"
        new="$(mktemp "${wallpapers}/XXXXX")"
        curl "$url" > "$new"
        ln -sf "$new" "$wallpaper"
        xwallpaper --zoom "$wallpaper" ;;
    "") exit 1 ;;
    *) exit 1 ;;
esac
