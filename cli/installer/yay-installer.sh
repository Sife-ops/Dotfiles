#!/bin/sh

tmp=$(mktemp)
pushd $tmp
git clone https://aur.archlinux.org/yay
cd yay
makepkg -si
popd

