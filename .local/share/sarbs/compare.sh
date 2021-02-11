#!/bin/sh

sarbs="${HOME}/.local/share/sarbs/progs.csv"
larbs="${HOME}/.local/src/LARBS/progs.csv"

while read linea; do
    unset found
    a="$(echo "$linea" | cut -d ',' -f 2)"
    # echo "$a"
    while read lineb; do
        b="$(echo "$lineb" | cut -d ',' -f 2)"
        # echo "$b"
        if [ "$a" = "$b" ]; then
            found=1
            echo "$a not found in sarbs."
        fi
    done < "$sarbs"
    if [ -z "$found" ]; then
        echo "$linea" >> notinsarbs.csv
        echo "$a not found in sarbs."
    fi
done < "$larbs"

while read linea; do
    unset found
    a="$(echo "$linea" | cut -d ',' -f 2)"
    # echo "$a"
    while read lineb; do
        b="$(echo "$lineb" | cut -d ',' -f 2)"
        # echo "$b"
        if [ "$a" = "$b" ]; then
            found=1
            echo "$a found in larbs."
        fi
    done < "$larbs"
    if [ -z "$found" ]; then
        echo "$linea" >> notinlarbs.csv
        echo "$a not found in larbs."
    fi
done < "$sarbs"
