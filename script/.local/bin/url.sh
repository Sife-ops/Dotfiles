#!/bin/sh
# url action menu
# todo:
# queue downloads with nq
# add RSS feed

[ -n "$1" ] && url="$1" || url=$(xclip -o -selection clipboard)

mkdir -p "${DOWNLOADS:-${HOME}/Downloads}"

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

chosen=$(main_list | dmenu ${DMENU_OPTS} -i -l 20)
case "$chosen" in
    open) chosen=$(open_list | dmenu ${DMENU_OPTS} -i -l 20)
        case "$chosen" in
            browser) $BROWSER "$url" ;;
            # mpv) : ;;
            # sxiv) : ;;
            *) exit 1 ;;
        esac ;;
    download) chosen=$(download_list | dmenu ${DMENU_OPTS} -i -l 20) && cd "${DOWNLOADS:-${HOME}/Downloads}"
        case "$chosen" in
            curl) ${TERMEXEC:-xterm -e} curl -LO $url ;;
            youtube-dl) chosen=$(youtubedl_list | dmenu ${DMENU_OPTS} -i -l 20)
                case "$chosen" in
                    automatic) ${TERMEXEC:-xterm -e} youtube-dl $url ;;
                    "best quality") ${TERMEXEC:-xterm -e} youtube-dl -f bestvideo+bestaudio $url ;;
                    "audio only") ${TERMEXEC:-xterm -e} youtube-dl -x --audio-format mp3 $url ;;
                    "audio playlist") ${TERMEXEC:-xterm -e} youtube-dl -i --extract-audio --audio-format mp3 $url ;;
                    *) exit 1 ;;
                esac ;;
            *) exit 1 ;;
        esac ;;
    *) exit 1 ;;
esac
