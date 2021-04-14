#!/bin/sh
# url action menu
# todo: queue downloads with nq

[ -n "$1" ] && url="$1" || url=$(xclip -o -selection clipboard)

downloads="${HOME}/Downloads"
mkdir -p "$downloads"

main_list () {
    echo "open"
    echo "download"
    # echo "mpv"
    # echo "sxiv"
}

open_list () {
    echo "browser"
    echo "mpv"
    echo "sxiv"
}

download_list () {
    echo "curl"
    echo "youtube-dl"
}

youtubedl_list () {
    echo "automatic"
    echo "best quality"
    echo "audio only"
    echo "audio playlist"
}

chosen=$(main_list | ${DMENU_CMD})
case "$chosen" in
    open) chosen=$(open_list | ${DMENU_CMD})
        case "$chosen" in
            browser) $BROWSER "$url" ;;
            # mpv) : ;;
            # sxiv) : ;;
            *) exit 1 ;;
        esac ;;
    download) chosen=$(download_list | ${DMENU_CMD}) && cd "$downloads"
        case "$chosen" in
            curl) $TERMEXEC curl -LO $url ;;
            youtube-dl) chosen=$(youtubedl_list | ${DMENU_CMD})
                case "$chosen" in
                    automatic) $TERMEXEC youtube-dl $url ;;
                    "best quality") $TERMEXEC youtube-dl -f bestvideo+bestaudio $url ;;
                    "audio only") $TERMEXEC youtube-dl -x --audio-format mp3 $url ;;
                    "audio playlist") $TERMEXEC youtube-dl -i --extract-audio --audio-format mp3 $url ;;
                    *) exit 1 ;;
                esac ;;
            *) exit 1 ;;
        esac ;;
    *) exit 1 ;;
esac
