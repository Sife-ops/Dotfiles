#!/bin/sh
# dmenu unit calculator

. menu.sh

if which checkdeps.sh 1>/dev/null 2>&1; then
    checkdeps.sh bc || exit 1; fi

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

hexadecimal=1
decimal=1
binary=1
octal=1
printf '%s' "$input" | grep '[A-F]' >/dev/null && unset decimal && unset binary && unset octal
printf '%s' "$input" | grep '[8-9]' >/dev/null && unset binary && unset octal
printf '%s' "$input" | grep '[2-7]' >/dev/null && unset binary

#^
bc_(){
    echo "$1" | bc
}

h2b(){
    bc_ "ibase=16; obase=2; $1"
}

h2d(){
    bc_ "ibase=16; $1"
}

h2o(){
    bc_ "ibase=16; obase=8; $1"
}

d2b(){
    bc_ "obase=2; $1"
}

d2h(){
    bc_ "obase=16; $1"
}

d2o(){
    bc_ "obase=8; $1"
}

o2b(){
    bc_ "ibase=8; obase=2; $1"
}

o2d(){
    bc_ "ibase=8; $1"
}

o2h(){
    bc_ "obase=16; ibase=8; $1"
}

b2d(){
    bc_ "ibase=2; $1"
}

b2h(){
    bc_ "ibase=2; obase=10000; $1"
}

b2o(){
    bc_ "ibase=2; obase=1000; $1"
}

dotted(){
    for i in $(seq $((dots + 1))); do
        $1 "$(echo "$input" | cut -d '.' -f "$i")"
    done | paste -d '.' $(seq -s ' ' $((dots + 1)) | tr '[:alnum:]' '-')
}
#$

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

main_list="$hex
$([ -n "$decimal" ] && echo "$dec")
$([ -n "$octal" ] && echo "$oct")
$([ -n "$binary" ] && echo "$bin")"
main_list="$(echo "$main_list" | sed '/^$/d')"

choose "$main_list" "input"
case "$chosen" in
    "") exit 1 ;;
    *) clipboard yank "$(echo "$chosen" | cut -d ':' -f 2 | tr -d "[:space:]")" ;;
esac

# vim: fdm=marker fmr=#^,#$
