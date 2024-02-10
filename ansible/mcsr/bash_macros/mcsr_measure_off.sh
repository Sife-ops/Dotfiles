#!/bin/bash

. mcsr_gui.sh
. mcsr_config.sh

w=$(xdotool selectwindow)
xdotool key --window $w Escape
xdotool key --window $w F3
xdotool key --window $w Escape
wmctrl -i -r $w -e 0,0,$offset_y,$screen_w,$screen_h
xdotool mousemove $options click 1
xdotool mousemove $fov_qp click 1
xdotool mousemove $controls click 1
xdotool mousemove $mouse_settings click 1
xdotool mousemove $sense click 1
xdotool key --window $w Escape
xdotool key --window $w Escape
