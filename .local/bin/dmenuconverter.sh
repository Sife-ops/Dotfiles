#!/bin/bash
# dmenu unit calculator
# todo:
# unit conversion
# arbitrary base conversion

#^ macros
shopt -s expand_aliases
alias dmenucmd='dmenu -b -i -l 20'
#$

#^ functions
function b2d(){ #^
    printf 'bin -> dec: %s\n' $(bc <<< "ibase=2; $1")
}

function b2h(){
    printf 'bin -> hex: %s\n' $(bc <<< "ibase=2; obase=10000; $1")
}

function b2o(){
    printf 'bin -> oct: %s\n' $(bc <<< "ibase=2; obase=1000; $1")
}

function d2b(){
    printf 'dec -> bin: %s\n' $(bc <<< "obase=2; $1")
}

function d2h(){
    printf 'dec -> hex: %s\n' $(bc <<< "obase=16; $1")
}

function d2o(){
    printf 'dec -> oct: %s\n' $(bc <<< "obase=8; $1")
}

function h2b(){
    printf 'hex -> bin: %s\n' $(bc <<< "ibase=16; obase=2; $1")
}

function h2d(){
    printf 'hex -> dec: %s\n' $(bc <<< "ibase=16; $1")
}

function h2o(){
    printf 'hex -> oct: %s\n' $(bc <<< "ibase=16; obase=8; $1")
}

function o2b(){
    printf 'oct -> bin: %s\n' $(bc <<< "ibase=8; obase=2; $1")
}

function o2d(){
    printf 'oct -> dec: %s\n' $(bc <<< "ibase=8; $1")
}

function o2h(){
    printf 'oct -> hex: %s\n' $(bc <<< "obase=16; ibase=8; $1")
} #$

function dec(){ #^
    d2b "$1"
    d2h "$1"
    d2o "$1"
}

function bin(){
    b2d "$1"
    b2h "$1"
    b2o "$1"
}

function hex(){
    h2b "$1"
    h2d "$1"
    h2o "$1"
}

function oct(){
    o2b "$1"
    o2d "$1"
    o2h "$1"
} #$ #$

#^ input validator
[ -z "$1" ] && input=$(xclip -o -selection clipboard) || input="$1"
input=$(echo "$input" | tr "[:lower:]" "[:upper:]")
#$

while true; do #^

    unset d
    unset b
    unset o
    printf '%s' "$input" | grep '[^A-F0-9]' >/dev/null && exit 1
    printf '%s' "$input" | grep '[A-F]' >/dev/null && d=1 && b=1 && o=1
    printf '%s' "$input" | grep '[8-9]' >/dev/null && b=1 && o=1
    printf '%s' "$input" | grep '[2-7]' >/dev/null && b=1
    printf '%s' "$input" | grep '[2-9]' >/dev/null && b=1

    output=$(\
        cat \
        <(hex "$input") \
        <([ -z "$d" ] && dec "$input") \
        <([ -z "$o" ] && oct "$input") \
        <([ -z "$b" ] && bin "$input") |
            dmenucmd -p "$input" |
            cut -d ':' -f 2 |
            tr -d "[:space:]" \
    )

    action=$(printf 'send to clipboard\nback' | dmenucmd -p "$output")
    case "$action" in
        'send to clipboard')
            echo "$output" |
                xclip -i -selection clipboard
                exit 0 ;;
        back) : ;;
        *) exit 0 ;;
        # convert) input="$output" ;;
    esac

done #$

# vim: fdm=marker fmr=#^,#$
