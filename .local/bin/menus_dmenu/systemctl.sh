#!/bin/sh
# systemctl wrapper

unit=$(systemctl list-unit-files --no-pager | cut -d ' ' -f 1 |
    grep '.*\.service$' | ${DMENU_CMD:-dmenu -i -l 10} || kill 0)

status () {
    echo "start"
    echo "stop"
    echo "enable"
    echo "disable"
    echo "==== STATUS ===================================================================================================================================================================================================================================================================================================================================================================================================="
    systemctl status $unit --no-pager | sed -E 's/(.*)/= \1/'
}

action=$(status | ${DMENU_CMD:-dmenu -i} -l 999 || kill 0)

case $action in
    start) sudo systemctl start $unit ;;
    stop) sudo systemctl stop $unit ;;
    enable) sudo systemctl enable $unit ;;
    disable) sudo systemctl disable $unit ;;
esac
