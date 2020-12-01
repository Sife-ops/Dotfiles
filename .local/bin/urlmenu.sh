#!/bin/sh

msg_help() { echo \
"Usage:
    urlmenu.sh [URL]"
}

if which checkdeps.sh >/dev/null; then
    if ! checkdeps.sh dmenu; then exit 1; fi fi

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
        id=$(tsp curl -LO --output-dir ~/Downloads "$url")
        notify-send "⏳ Queuing $base..."
        tsp -D "$id" notify-send "👍 $base done." ;;

	mpv)
        setsid -f mpv -quiet "$url" >/dev/null 2>&1 ;;

    sxiv)
        exit ;;

    youtube-dl)
        chosen=$(printf "automatic\\nbest quality\\nmedium quality\\nlow quality\\naudio only\\naudio playlist" |
            dmenu -b -i -l 20 -p "ytdl")

        case $chosen in
            automatic)
                id=$(tsp youtube-dl -o ~/Downloads/%\(title\)s.%\(ext\)s "$url")
                notify-send "⏳ Queuing $base..."
                tsp -D "$id" notify-send "👍 $base done." ;;

            "best quality")
                id=$(tsp youtube-dl -f bestvideo+bestaudio -o \
                    ~/Downloads/%\(title\)s.%\(ext\)s "$url")
                notify-send "⏳ Queuing $base..."
                tsp -D "$id" notify-send "👍 $base done." ;;

            "medium quality")
                : ;;

            "low quality")
                : ;;

            "audio only")
                id=$(tsp youtube-dl -x --audio-format mp3 -o \
                    ~/Downloads/%\(title\)s.%\(ext\)s "$url")
                notify-send "⏳ Queuing $base..."
                tsp -D "$id" notify-send "👍 $base done." ;;

            "audio playlist")
                id=$(tsp youtube-dl -i --extract-audio --audio-format mp3 -o \
                    ~/Downloads/%\(title\)s.%\(ext\)s "$url")
                notify-send "⏳ Queuing $base..."
                tsp -D "$id" notify-send "👍 $base done." ;;

            *) exit ;;
        esac ;;
    *) exit ;;
esac
