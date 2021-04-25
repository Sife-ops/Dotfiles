#!/bin/sh
# todo:

updates=$(mktemp /tmp/updates.XXXXXX)
export updates

pidfile=$(mktemp /tmp/pidfile.XXXXXX)
export pidfile

on_click () {
    $TERMEXEC yay -Syu &
    cat $pidfile | xargs -I{} kill {}
    rm $pidfile
}
export -f on_click

while true; do
    checkupdates > $updates
    count=$(wc -l $updates | cut -d ' ' -f 1)
    if [ $count -gt 0 ]; then
        notify-send 'pacman updates' "$(cat $updates)"
        mpv "${SFX}/win95/DA_EXCLA.WAV" 1>/dev/null 2>&1 &
        yad --notification \
            --command="sh -c on_click" \
            --image="system-software-update" &
        echo $! >> $pidfile
    fi
    rm $updates
    sleep $1
done
rm $pidfile

