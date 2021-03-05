#!/bin/sh

sleep 1

xrandr \
    --dpi 108 \
    --output DP-0 \
        --off \
    --output DP-1 \
        --off \
    --output DP-2 \
        --off \
    --output DP-3 \
        --off \
    --output HDMI-0 \
        --mode 1360x768 \
        --pos 1440x1792 \
        --rotate normal \
    --output DP-4 \
        --left-of HDMI-0 \
        --mode 2560x1440 \
        --pos 0x0 \
        --rotate left \
    --output DP-5 \
        --off

sleep 1

setwallpaper.sh
offlineimap -c ~/.config/offlineimap/offlineimaprc &
