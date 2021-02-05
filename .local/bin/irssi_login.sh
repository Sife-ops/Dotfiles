#!/bin/sh
# login wrapper for irssi

sasl_gpg_conf="${XDG_CONFIG_HOME:-${HOME}/config}/irssi/sasl_gpg.conf"
irssi_conf="${XDG_CONFIG_HOME:-${HOME}/config}/irssi/config"

decryptandescape(){
    gpg --decrypt "$1" 2>/dev/null |
        sed 's/\\/\\\\/g' |
        sed 's/\$/\\\$/g' |
        sed 's/\&/\\\&/g' |
        sed 's/\*/\\\*/g' |
        sed 's/\./\\\./g' |
        sed 's/\//\\\//g' |
        sed 's/\^/\\\^/g'
}

while read ident user pass_file; do
    case "$ident" in
        '#') : ;;
        *) pass="$(eval "decryptandescape $pass_file")"
           ln="$(grep -n "$ident" "$irssi_conf" | cut -d ':' -f 1)"
           sed -i -e "${ln},$((ln + 2)) s/<+user+>/${user}/" \
                  -e "${ln},$((ln + 2)) s/<+pass+>/${pass}/" "$irssi_conf" ;;
    esac
done < "$sasl_gpg_conf"

irssi --config="$irssi_conf" --home="$(dirname "$irssi_conf")"

while read ident user pass_file; do
    case "$ident" in
        '#') : ;;
        *) pass="$(eval "decryptandescape $pass_file")"
           ln="$(grep -n "$ident" "$irssi_conf" | cut -d ':' -f 1)"
           sed -i -e "${ln},$((ln + 2)) s/\(sasl_username = \"\)\(.*\)\(\";\)/\1<+user+>\3/" \
                  -e "${ln},$((ln + 2)) s/\(sasl_password = \"\)\(.*\)\(\";\)/\1<+pass+>\3/" "$irssi_conf" ;;
    esac
done < "$sasl_gpg_conf"
