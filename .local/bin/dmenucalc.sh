#!/bin/sh
# dmenu unit calculator
# todo:
# unit conversion
# arbitrary base conversion

if which checkdeps.sh 1>/dev/null 2>&1; then #^
    checkdeps.sh dmenu bc || exit 1; fi

export BC_LINE_LENGTH=0

alias dmenucmd='dmenu -b -i -l 20' #$

bc_(){ #^
    # printf "$1\n" | bc
    echo "$1" | bc
} #$

hex(){ #^
    printf 'hex -> bin: %s\n' "$(bc_ "ibase=16; obase=2; $1")"
    printf 'hex -> dec: %s\n' "$(bc_ "ibase=16; $1")"
    printf 'hex -> oct: %s\n' "$(bc_ "ibase=16; obase=8; $1")"
}

dec(){
    printf 'dec -> bin: %s\n' "$(bc_ "obase=2; $1")"
    printf 'dec -> hex: %s\n' "$(bc_ "obase=16; $1")"
    printf 'dec -> oct: %s\n' "$(bc_ "obase=8; $1")"
}

oct(){
    printf 'oct -> bin: %s\n' "$(bc_ "ibase=8; obase=2; $1")"
    printf 'oct -> dec: %s\n' "$(bc_ "ibase=8; $1")"
    printf 'oct -> hex: %s\n' "$(bc_ "obase=16; ibase=8; $1")"
}

bin(){
    printf 'bin -> dec: %s\n' "$(bc_ "ibase=2; $1")"
    printf 'bin -> hex: %s\n' "$(bc_ "ibase=2; obase=10000; $1")"
    printf 'bin -> oct: %s\n' "$(bc_ "ibase=2; obase=1000; $1")"
} #$

#^ validate input
[ -z "$1" ] && input=$(xclip -o -selection clipboard) || input="$1"
input=$(echo "$input" |
    tr "[:lower:]" "[:upper:]" |
    sed 's/\(^0[BXbx]\)\(.*\)/\2/')
#$

#^ main menu
unset d
unset b
unset o
printf '%s' "$input" | grep '[^A-F0-9]' >/dev/null && exit 1
printf '%s' "$input" | grep '[A-F]' >/dev/null && d=1 && b=1 && o=1
printf '%s' "$input" | grep '[8-9]' >/dev/null && b=1 && o=1
printf '%s' "$input" | grep '[2-7]' >/dev/null && b=1
printf '%s' "$input" | grep '[2-9]' >/dev/null && b=1

output=$(\
    (hex "$input";
    [ -z "$d" ] && dec "$input";
    [ -z "$o" ] && oct "$input";
    [ -z "$b" ] && bin "$input";) |
        dmenucmd -p "$input" |
        cut -d ':' -f 2 |
        tr -d "[:space:]")

case "$output" in
    "") exit 1 ;;
    *) echo "$output" |
        xclip -i -selection clipboard
        exit 0 ;;
esac
#$

# vim: fdm=marker fmr=#^,#$
