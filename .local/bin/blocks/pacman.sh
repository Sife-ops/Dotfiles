#!/bin/sh
# print number of upgradable packages

statusbar="${STATUSBAR:-${XDG_DATA_HOME:-${HOME}/.local/share}/statusbar}"

icon="📦"
pkgs=$(grep 'pacman' "$statusbar" | tail -n1 | cut -d ':' -f 2)

if test "$pkgs" -eq "$pkgs" 1>/dev/null 2>&1; then   # evil hack
    if [ "$pkgs" -lt "1" ]; then
        printf ""
    else
        printf "%s %s" "$icon" "$pkgs"
    fi
else
    printf ""
fi
