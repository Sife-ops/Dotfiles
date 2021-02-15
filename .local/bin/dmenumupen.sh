#!/bin/sh

. menu.sh

if [ -n "$1" ]; then
   romd="$1"
else
   romd="${N64ROMS:-${XDG_DATA_DIR:-${HOME}/.local/share}/roms/n64}"
fi

configd="${XDG_CONFIG_HOME:-${HOME}/.config}/mupen64plus"
config="${configd}/mupen64plus.cfg"
template="${configd}/template"
controllers="${configd}/controllers"

stuff(){
    while IFS= read -r line; do
        case $line in
            "###c${1}###")
                sed "s/<+dev+>/$(( $1 - 1 ))/" "${controllers}/${2}" \
                    >> "${config}_" ;;
            *)
                echo "$line" \
                    >> "${config}_" ;;
        esac
    done < "$3"
    mv ${config}_ ${config}
}

main_list="$(dir_contents "${romd}/")"
controller_list="$(dir_contents "${controllers}/")"
video_list='False,640,480
True,1920,1080
True,2560,1440'

choose "$main_list" 'N64'; [ -z "$chosen" ] && exit 1
rom="$chosen"
choose "$controller_list" 'player 1'; [ -z "$chosen" ] && exit 1
truncate -s 0 "$config"
stuff 1 "$chosen" "$template"
choose "$controller_list" 'player 2'; [ -z "$chosen" ] && chosen='unplugged'
stuff 2 "$chosen" "$config"
choose "$controller_list" 'player 3'; [ -z "$chosen" ] && chosen='unplugged'
stuff 3 "$chosen" "$config"
choose "$controller_list" 'player 4'; [ -z "$chosen" ] && chosen='unplugged'
stuff 4 "$chosen" "$config"
choose "$video_list" 'video'; [ -z "$chosen" ] && exit 1
full="$(echo "$chosen" | cut -d ',' -f 1)"
width="$(echo "$chosen" | cut -d ',' -f 2)"
height="$(echo "$chosen" | cut -d ',' -f 3)"
sed -i -e "s/<+full+>/$full/" \
    -e "s/<+width+>/$width/" \
    -e "s/<+height+>/$height/" "$config"

mupen64plus "${romd}/${rom}"
