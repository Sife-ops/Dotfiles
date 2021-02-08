#!/bin/sh

# Increase autorepeat rate
xset r rate 300 50

# Swap ESC and Caps Lock
setxkbmap -option caps:swapescape

# Start WM
. ${XDG_CONFIG_HOME:-${HOME}/.config}/dwm/startup
while :; do
	ssh-agent dwm
done
