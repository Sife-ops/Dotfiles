#!/bin/sh

tmp_file=$(mktemp)

xy () {
    xdt_o=$(xdotool getmouselocation)
    x=$(echo $xdt_o | cut -d " " -f 1 | cut -d ":" -f 2)
    y=$(echo $xdt_o | cut -d " " -f 2 | cut -d ":" -f 2)
    echo "$x $y"
}

read -p "Options"
echo "options=\"$(xy)\"" >> $tmp_file

read -p "FOV 30"
echo "fov_30=\"$(xy)\"" >> $tmp_file

read -p "FOV Quake Pro"
echo "fov_qp=\"$(xy)\"" >> $tmp_file

read -p "controls"
echo "controls=\"$(xy)\"" >> $tmp_file

read -p "Mouse Settings"
echo "mouse_settings=\"$(xy)\"" >> $tmp_file

read -p "Yawn"
echo "yawn=\"$(xy)\"" >> $tmp_file

read -p "Default Sensitivity"
echo "sense=\"$(xy)\"" >> $tmp_file

read -p "Video Settings"
echo "video_settings=\"$(xy)\"" >> $tmp_file

read -p "Render Distance 8"
echo "rd_8=\"$(xy)\"" >> $tmp_file

read -p "Entity Distance 50%"
echo "ed_8=\"$(xy)\"" >> $tmp_file

echo
echo $tmp_file
echo
cat $tmp_file
echo
