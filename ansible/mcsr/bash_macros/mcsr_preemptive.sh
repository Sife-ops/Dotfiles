#!/bin/bash

. mcsr_gui.sh
. mcsr_config.sh

w=$(xdotool selectwindow)
xdotool key --window $w Escape
xdotool mousemove $options click 1
xdotool mousemove $fov_30 click 1
xdotool mousemove $video_settings click 1
xdotool mousemove $rd_8 click 1
xdotool mousemove $ed_50 click 1
xdotool key --window $w Escape
xdotool key --window $w Escape
