#!/bin/sh

pkgs=$(pacman -Qu | grep -Fcv "[ignored]")
notify-send 'pacman' "$pkgs new updates."
