#!/bin/sh
# print last notification

notifications="${NOTIFICATIONS:-${XDG_DATA_HOME:-${HOME}/.local/share}/notifications}"

notif=$(tail -n1 "$notifications")
echo "$notif"
