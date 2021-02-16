#!/bin/sh
# interface for mupen64plus

. menu.sh

if [ -n "$1" ]; then
   romd="$1"
else
   romd="${N64ROMS:-${XDG_DATA_DIR:-${HOME}/.local/share}/roms/n64}"
fi

configd="${XDG_CONFIG_HOME:-${HOME}/.config}/mupen64plus"
config="${configd}/mupen64plus.cfg"
config_tmp="$(mktemp /tmp/dmenumupen.XXX)"
config_template="${configd}/template"
controllers="${configd}/controllers"

assign(){
    tmp="$(mktemp /tmp/dmenumupen.XXXX)"
    while IFS= read -r line; do
        case "$line" in
            "<+c${1}+>")
                sed "s/<+dev+>/${2}/" "$3" \
                    >> "$tmp" ;;
            *)
                echo "$line" \
                    >> "$tmp" ;;
        esac
    done < "$4"
    mv "$tmp" "$4"
}

rom_list="$(find "${romd}" -type f -exec basename {} \;)"

joystick_list="unplugged
$(find "/dev/input" -regex '^.*/js[0-9]$' -exec basename {} \;)"

controller_list="$(find "${controllers}" -type f -exec basename {} \;)"

video_list='Windowed,640x480
Windowed,1920x1080
Fullscreen,1920x1080
Fullscreen,2560x1440'

choose "$rom_list" 'N64'; [ -z "$chosen" ] && exit 1
rom="$chosen"

cp "$config_template" "$config_tmp"

for port in $(seq 4); do
    choose "$joystick_list" "device"
    dev="$(echo "$chosen" | tr -dc '[:digit:]')"
    case $chosen in
        unplugged)
            assign "$port" "-1" "${configd}/unplugged" "$config_tmp" ;;
        *)
            choose "$controller_list" "controller"
            assign "$port" "$dev" "${controllers}/${chosen}" "$config_tmp" ;;
        "") exit 1 ;;
    esac
done

choose "$video_list" 'video'; [ -z "$chosen" ] && exit 1
full="$(echo "$chosen" | cut -d ',' -f 1)"
case $full in
    Fullscreen) full=True ;;
    Windowed) full=False ;;
esac
width="$(echo "$chosen" | cut -d ',' -f 2 | cut -d 'x' -f 1)"
height="$(echo "$chosen" | cut -d ',' -f 2 | cut -d 'x' -f 2)"
sed -i -e "s/<+full+>/$full/" \
    -e "s/<+width+>/$width/" \
    -e "s/<+height+>/$height/" "$config_tmp"

mv "$config_tmp" "$config"

mupen64plus "${romd}/${rom}"
