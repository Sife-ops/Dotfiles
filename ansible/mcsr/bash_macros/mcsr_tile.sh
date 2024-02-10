#!/bin/bash

. mcsr_config.sh

while read wid; do
    pid=$(xprop -id $wid _NET_WM_PID | cut -d " " -f 3)
    if stat /proc/$pid/cwd/instance_num 1>/dev/null 2>&1; then
        # xprop -id $wid -f _MOTIF_WM_HINTS 32c -set _MOTIF_WM_HINTS "0x2, 0x0, 0x2, 0x0, 0x0"
        inst_num=$(cat /proc/$pid/cwd/instance_num)
        inst_x=$(( (inst_w * (inst_num % cols)) + offset_x ))
        inst_y=$(( (inst_h * ((((inst_num + 1) + (cols - 1)) / cols) - 1)) + offset_y ))
	    wmctrl -i -r $wid -e 0,$inst_x,$inst_y,$inst_w,$inst_h
    fi
done < <(wmctrl -l | grep $title_pat | cut -d " " -f 1)
