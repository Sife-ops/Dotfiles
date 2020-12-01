#!/bin/sh
# print mpd info

filter() { mpc | sed "/^volume:/d;s/\\&/&amp;/g;s/\\[paused\\].*/⏸/g;/\\[playing\\].*/d" | paste -sd ' ';}

pidof -x mpdup >/dev/null 2>&1 || mpdup >/dev/null 2>&1 &
