#!/bin/sh
# url action menu

if which checkdeps.sh >/dev/null 2>&1; then
    checkdeps.sh dmenu || exit 1; fi

msg_help() { echo \
"Usage:
    urlmenu.sh [URL]"
}

alias st_cmd='st -c task -e sh -c'

[ -z $1 ] \
    && url="$(xclip -selection clipboard -o)" \
    || url="$1"

base="$(basename "$url")"
chosen=$(printf " -> ${base} <-\\nadd feed\\nbrowser\\ncopy to clipboard\\ncurl\\nmpv\\nsxiv\\nyoutube-dl" |
    dmenu -b -i -l 20 -p "action")

case $chosen in
    "add feed")
        exit ;;

	browser)
        setsid -f "$BROWSER" "$url" >/dev/null 2>&1 ;;

    "copy to clipboard")
        echo "$url" | xclip -selection clipboard ;;

    curl)
        notify-send "⏳downloading $base"
        st_cmd "curl -LO --output-dir ~/Downloads $url && notify-send \"👍$base done\"; $SHELL" ;;

	mpv)
        setsid -f mpv -quiet "$url" >/dev/null 2>&1 ;;

    sxiv)
        exit ;;

    youtube-dl)
        chosen=$(printf "automatic\\nbest quality\\naudio only\\naudio playlist" |
            dmenu -b -i -l 20 -p "ytdl")

        case $chosen in
            automatic)
                notify-send "⏳downloading $base..."
                st_cmd "youtube-dl -o ~/Downloads/%\(title\)s.%\(ext\)s $url && notify-send \"👍$base done\"; $SHELL" ;;

            "best quality")
                notify-send "⏳downloading $base..."
                st_cmd "youtube-dl -f bestvideo+bestaudio -o ~/Downloads/%\(title\)s.%\(ext\)s $url && notify-send \"👍$base done\"; $SHELL" ;;

            "audio only")
                notify-send "⏳downloading $base..."
                st_cmd "youtube-dl -x --audio-format mp3 -o ~/Downloads/%\(title\)s.%\(ext\)s "$url" && notify-send \"👍$base done\"; $SHELL" ;;

            "audio playlist")
                notify-send "⏳downloading $base..."
                st_cmd "youtube-dl -i --extract-audio --audio-format mp3 -o ~/Downloads/%\(title\)s.%\(ext\)s "$url" && notify-send \"👍$base done\"; $SHELL" ;;

            *) exit ;;
        esac ;;
    *) exit ;;
esac
