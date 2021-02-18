#!/bin/sh
# print disk usage

location=${1:-/}

[ -d "$location" ] || exit

case "$location" in
	"/home"* ) icon="🏠" ;;
	"/mnt"* ) icon="💾" ;;
	*) icon="💽";;
esac

printf "%s: %s\n" "$icon" "$(df -h "$location" | awk ' /[0-9]/ {print $3 "/" $2}')"
