#!/bin/sh
# login wrapper for irssi

pgrep -x irssi && echo "already running" && exit 1

sasl_gpg_conf="${XDG_CONFIG_HOME:-${HOME}/config}/irssi/sasl_gpg.conf"

irssi_conf="${XDG_CONFIG_HOME:-${HOME}/config}/irssi/config"
irssi_conf_sasl="${XDG_CONFIG_HOME:-${HOME}/config}/irssi/config_sasl"
cp "$irssi_conf" "$irssi_conf_sasl"

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
        '#'|'') : ;;
        *) pass="$(eval "decryptandescape $pass_file")"
           sed -i -e "s/<+${ident}:user+>/${user}/" \
                  -e "s/<+${ident}:pass+>/${pass}/" "$irssi_conf_sasl" ;;
    esac
done < "$sasl_gpg_conf"

irssi --config="$irssi_conf_sasl" --home="$(dirname "$irssi_conf")"
rm -rf "$irssi_conf_sasl"
