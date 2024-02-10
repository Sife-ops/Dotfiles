#!/bin/bash

. mcsr_config.sh

xdotool click 1
w=$(xdotool getactivewindow)
wmctrl -i -a $w
wmctrl -i -r $w -e 0,0,$offset_y,$screen_w,$screen_h
# xdotool key --window $w Escape # doesnt work lol
