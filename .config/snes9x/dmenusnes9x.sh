#!/bin/sh
# interface for snes9x

. menu.sh

if [ -n "$1" ]; then
   romd="$1"
else
   romd="${SNESROMS:-${XDG_DATA_DIR:-${HOME}/.local/share}/roms/snes}"
fi

configd="${XDG_CONFIG_HOME:-${HOME}/.config}/snes9x"
config="${configd}/snes9x.conf"
config_tmp="$(mktemp /tmp/snes9x.XXX)"
config_template="${configd}/template"
controllers="${configd}/controllers"

assign_port(){
    case $2 in
        "(null)") sed -i "s/<+pad${1}+>/none/" "$4" ;;
        *) sed -i "s/<+pad${1}+>/pad${1}/" "$4" ;;
    esac
    sed -i "s!<+dev${1}+>!$2!" "$4"

    tmp="$(mktemp /tmp/snes9x.XXXX)"
    while IFS= read -r line; do
        case "$line" in
            "<+con${1}+>") sed "s/<+js+>/$(( $1 - 1 ))/" "$3" >> "$tmp" ;;
            *) echo "$line" >> "$tmp" ;;
        esac
    done < "$4"
    mv "$tmp" "$4"
}

rom_list="$(find "${romd}" -type f -exec basename {} \;)"

joystick_list="unplugged
$(find "/dev/input" -regex '^.*/js[0-9]$' | tac)"

controller_list="$(find "${controllers}" -type f -exec basename {} \;)"

mode_list='1, Video mode: Blocky (default)
2, Video mode: TV
3, Video mode: Smooth
4, Video mode: SuperEagle
5, Video mode: 2xSaI
6, Video mode: Super2xSaI
7, Video mode: EPX
8, Video mode: hq2x'

choose "$rom_list" 'N64'; [ -z "$chosen" ] && exit 1
rom="$chosen"

cp "$config_template" "$config_tmp"

for port in $(seq 2); do
    choose "$joystick_list" "device"
    dev="$chosen"
    case $dev in
        unplugged)
            assign_port "$port" "(null)" "${configd}/unplugged" "$config_tmp" ;;
        "")
            exit 1 ;;
        *)
            choose "$controller_list" "controller"
            controller="${controllers}/${chosen}"
            assign_port "$port" "$dev" "$controller" "$config_tmp" ;;
    esac
done

choose "$mode_list" 'mode'; [ -z "$chosen" ] && exit 1
mode="$(echo "$chosen" | cut -d ',' -f 1)"
sed -i "s/<+mode+>/$mode/" "$config_tmp"

mv "$config_tmp" "$config"

snes9x -conf "$config" "${romd}/${rom}"
