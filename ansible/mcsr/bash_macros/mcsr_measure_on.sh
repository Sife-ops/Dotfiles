#!/bin/bash

. mcsr_gui.sh
. mcsr_config.sh

w=$(xdotool selectwindow)
xdotool key --window $w Escape
xdotool key --window $w F3
xdotool key --window $w Escape
xdotool mousemove $options click 1
xdotool mousemove $fov_30 click 1
xdotool mousemove $controls click 1
xdotool mousemove $mouse_settings click 1
xdotool mousemove $yawn click 1
pos_x=$(( (screen_h * ((measure_resize_factor - 1) / -2)) + offset_y ))
size_h=$(( screen_h * measure_resize_factor ))
wmctrl -i -r $w -e 0,0,$pos_x,$screen_w,$size_h
xdotool key --window $w Escape
xdotool key --window $w Escape
