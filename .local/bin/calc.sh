#!/bin/sh
# dmenu unit calculator
# sinitic numbers
# currency?

. math.sh
. menu.sh

export BC_LINE_LENGTH=0

if [ -n "$1" ]; then
    input="$1"
else
    input="$(clipboard put)"
fi

input="$(echo "$input" |
    tr '[:lower:]' '[:upper:]' |
    tr -dc '[A-F0-9.]' |
    sed 's/^0*//')"

if echo "$input" | grep '\.' 1>/dev/null 2>&1; then
    dots="$(echo "$input" | tr -dc '.')"
    dots="${#dots}"
fi

dotted(){
    for i in $(seq $((dots + 1))); do
        $1 "$(echo "$input" | cut -d '.' -f "$i")"
    done | paste -d '.' $(seq -s ' ' $((dots + 1)) | tr '[:alnum:]' '-')
}

decimal=1
binary=1
octal=1
if echo "$input" | grep '[A-F]' >/dev/null; then
    input_decimal="$(h2d "$input")"
    unset decimal; unset binary; unset octal; fi
if echo "$input" | grep '[8-9]' >/dev/null; then
    unset binary; unset octal
if echo "$input" | grep '[2-7]' >/dev/null; then
    unset binary

#^
if [ -n "$dots" ]; then
    hex="$(printf 'hex -> bin: %s' "$(dotted h2b)")
$(printf 'hex -> dec: %s' "$(dotted h2d)")
$(printf 'hex -> oct: %s' "$(dotted h2o)")"

    dec="$(printf 'dec -> bin: %s' "$(dotted d2b)")
$(printf 'dec -> hex: %s' "$(dotted d2h)")
$(printf 'dec -> oct: %s' "$(dotted d2o)")"

    oct="$(printf 'oct -> bin: %s' "$(dotted o2b)")
$(printf 'oct -> dec: %s' "$(dotted o2d)")
$(printf 'oct -> hex: %s' "$(dotted o2h)")"

    bin="$(printf 'bin -> dec: %s' "$(dotted b2d)")
$(printf 'bin -> hex: %s' "$(dotted b2h)")
$(printf 'bin -> oct: %s' "$(dotted b2o)")"
else
    hex="$(printf 'hex -> bin: %s' "$(h2b "$input")")
$(printf 'hex -> dec: %s' "$(h2d "$input")")
$(printf 'hex -> oct: %s' "$(h2o "$input")")"

    dec="$(printf 'dec -> bin: %s' "$(d2b "$input")")
$(printf 'dec -> hex: %s' "$(d2h "$input")")
$(printf 'dec -> oct: %s' "$(d2o "$input")")"

    oct="$(printf 'oct -> bin: %s' "$(o2b "$input")")
$(printf 'oct -> dec: %s' "$(o2d "$input")")
$(printf 'oct -> hex: %s' "$(o2h "$input")")"

    bin="$(printf 'bin -> dec: %s' "$(b2d "$input")")
$(printf 'bin -> hex: %s' "$(b2h "$input")")
$(printf 'bin -> oct: %s' "$(b2o "$input")")"
fi
#$

main_list="~= base conversion =~
$hex
$([ -n "$decimal" ] && echo "$dec")
$([ -n "$octal" ] && echo "$oct")
$([ -n "$binary" ] && echo "$bin")
~= unit conversion =~"
main_list="$(echo "$main_list" | sed '/^$/d')"

choose "$main_list" "$input"
case "$chosen" in
    "") exit 1 ;;
    "~="*) exit 1 ;;
    *) clipboard yank "$(echo "$chosen" |
        cut -d ':' -f 2 |
        tr -d "[:space:]")" ;;
esac

# vim: fdm=marker fmr=#^,#$
