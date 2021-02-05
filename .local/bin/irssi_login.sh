#!/bin/sh
# login wrapper for irssi

sasl_gpg_conf="${XDG_CONFIG_HOME:-${HOME}/config}/irssi/sasl_gpg.conf"
irssi_conf="${XDG_CONFIG_HOME:-${HOME}/config}/irssi/config"

# pass_dir="${XDG_DATA_HOME:-${HOME}/.local/share}/gnupg"
# sasl_accts="sife:${pass_dir}/sifeatircdotfreenodedotnet.gpg;"
# accts_len="$(echo "$sasl_accts" | tr -dc ';')"
# accts_len="${#accts_len}"

decrypt_escape(){
    gpg --decrypt "$1" 2>/dev/null |
        sed 's/\\/\\\\/g' |
        sed 's/\$/\\\$/g' |
        sed 's/\&/\\\&/g' |
        sed 's/\*/\\\*/g' |
        sed 's/\./\\\./g' |
        sed 's/\//\\\//g' |
        sed 's/\^/\\\^/g'
}

while read user pass_file; do
    case "$user" in
        '#') : ;;
        *) pass="$(eval "decrypt_escape $pass_file")"
           sed -i -e "s/<+${user}:user+>/${user}/" \
                  -e "s/<+${user}:pass+>/${pass}/" "$irssi_conf" ;;
    esac
done < "$sasl_gpg_conf"

irssi --config="$irssi_conf" --home="$(dirname "$irssi_conf")"

while read user pass_file; do
    case "$user" in
        '#') : ;;
        *) pass="$(eval "decrypt_escape $pass_file")"
           sed -i -e "s/\(sasl_username = \"\)\(${user}\)\(\";\)/\1<+${user}:user+>\3/" \
                  -e "s/\(sasl_password = \"\)\(${pass}\)\(\";\)/\1<+${user}:pass+>\3/" "$irssi_conf"
    esac
done < "$sasl_gpg_conf"

# for acct in $(seq "$accts_len"); do
#     acct="$(echo "$sasl_accts" | cut -d ';' -f "$acct")"
#     user="$(echo "$acct" | cut -d ':' -f 1)"
#     pass_file="$(echo "$acct" | cut -d ':' -f 2)"
#     pass="$(gpg --decrypt "$pass_file" 2>/dev/null |
#         sed 's/\\/\\\\/g' |
#         sed 's/\$/\\\$/g' |
#         sed 's/\&/\\\&/g' |
#         sed 's/\*/\\\*/g' |
#         sed 's/\./\\\./g' |
#         sed 's/\//\\\//g' |
#         sed 's/\^/\\\^/g')"
#     sed -i -e "s/<+${user}:user+>/${user}/" \
#            -e "s/<+${user}:pass+>/${pass}/" config
# done

# irssi --config="${XDG_CONFIG_HOME:-${HOME}/.config}/irssi/config" \
#       --home="${XDG_CONFIG_HOME:-${HOME}/.config}/irssi"

# for acct in $(seq "$accts_len"); do
#     acct="$(echo "$sasl_accts" | cut -d ';' -f "$acct")"
#     user="$(echo "$acct" | cut -d ':' -f 1)"
#     pass_file="$(echo "$acct" | cut -d ':' -f 2)"
#     pass="$(gpg --decrypt "$pass_file" 2>/dev/null |
#         sed 's/\\/\\\\/g' |
#         sed 's/\$/\\\$/g' |
#         sed 's/\&/\\\&/g' |
#         sed 's/\*/\\\*/g' |
#         sed 's/\./\\\./g' |
#         sed 's/\//\\\//g' |
#         sed 's/\^/\\\^/g')"

#         sed -i -e "s/\(sasl_username = \"\)\(${user}\)\(\";\)/\1<+${user}:user+>\3/" \
#                -e "s/\(sasl_password = \"\)\(${pass}\)\(\";\)/\1<+${user}:pass+>\3/" config
# done
