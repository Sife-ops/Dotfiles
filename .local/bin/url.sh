#!/bin/sh
# general purpose url handler
# todo:
# test without notify-send present
# test nox

. menu.sh

#^ runtime check
[ -d "${DOWNLOADS:=${XDG_DOWNLOAD_DIR:-${HOME}/Downloads}}" ] || exit 1

[ -f "${BOOKMARKS:=${XDG_DATA_HOME:-${HOME}/.local/share}/bookmarks}" ] || \
    nobookmarks=t

[ -f "${FEEDS:=${XDG_CONFIG_HOME:-${HOME}/.config}/newsboat/urls}" ] || \
    nofeeds=t

which "${BROWSER:=firefox}" 1>/dev/null 2>&1 || nobrowser=t
which "${TERMINAL:=xfce4-terminal}" 1>/dev/null 2>&1 || noterm=t
case "$TERMINAL" in
    alacritty) termcmd='alacritty --class dd -e sh -c' ;; # todo
    st) termcmd='st -c dd -e sh -c' ;;
    urxvt) termcmd='urxvt -name dd -e sh -c' ;; # todo
    xfce4-terminal) : ;; # todo
    xterm) termcmd='xterm -class dd -e sh -c' ;; # todo
    "") : ;;
    *) : ;;
esac

which curl 1>/dev/null 2>&1 || nocurl=t
which mpv 1>/dev/null 2>&1 || nompv=t
which setsid 1>/dev/null 2>&1 || nosetsid=t
which sxiv 1>/dev/null 2>&1 || nosxiv=t
which tmux 1>/dev/null 2>&1 || notmux=t
which tsp 1>/dev/null 2>&1 || notsp=t
which youtube-dl 1>/dev/null 2>&1 || noytdl=t
#$

#^ input
while getopts "m" o; do
    case "${o}" in
        m) mouse=t ;;
        *) printf "Invalid option: -%s\n" "$o" ;;
    esac
done
shift $((OPTIND - 1))

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
[ -z "$nofeeds" ] && printf 'add feed\n'
[ -z "$nobookmarks" ] && printf 'add bookmark\n'
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

browser_list() { #^
    printf '$BROWSER\n'
    which brave 1>/dev/null 2>&1 && printf 'brave\n'
    which chromium 1>/dev/null 2>&1 && printf 'chromium\n'
    which firefox 1>/dev/null 2>&1 && printf 'firefox\n'
    which icecat 1>/dev/null 2>&1 && printf 'icecat\n'
    which librewolf 1>/dev/null 2>&1 && printf 'librewolf\n'
    which qutebrowser 1>/dev/null 2>&1 && printf 'qutebrowser\n'
} #$

bg_list(){ #^
[ -z "$notsp" ] && printf "task spooler\n"
[ -z "$nosetsid" ] && printf "setsid\n"
[ -z "$nox" ] && [ -z "$noterm" ] && printf "terminal\n"
[ -z "$notmux" ] && printf "tmux\n"
} #$ #$

bg_with(){ #^
    # bg_with <bg_type> <command>
    cd "$DOWNLOADS" || kill 0
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
    chosen=$(menu bg_list "background with")
    case "$chosen" in
        "task spooler") bg_with tsp "$1" ;;
        setsid) bg_with setsid "$1" ;;
        terminal) bg_with term "$1" ;;
        tmux) bg_with tmux "$1" ;;
        "") kill 0 ;;
        *) kill 0 ;;
    esac
} #$

browser_menu() { #^
    chosen=$(menu browser_list "browser")
    eval "$chosen $url"
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
    "add bookmark") echo "$url" >> "$BOOKMARKS" ;;
	browser) browser_menu ;;
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
