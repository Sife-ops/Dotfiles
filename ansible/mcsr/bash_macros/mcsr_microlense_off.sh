#!/bin/bash

. mcsr_gui.sh

w=$(xdotool selectwindow)
xdotool key --window $w Escape
xdotool mousemove $options click 1
xdotool mousemove $fov_qp click 1
xdotool key --window $w Escape
