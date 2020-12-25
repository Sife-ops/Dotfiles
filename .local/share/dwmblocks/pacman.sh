#!/bin/sh
# print number of upgradable packages

pkgs=$(pacman -Qu | grep -Fcv "[ignored]" | wc -l)
icon="📦"
[ "$pkgs" == "0" ] \
    && printf " " \
    || printf "%s%s" "$icon" "$pkgs"
