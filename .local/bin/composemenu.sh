#!/bin/sh

templates="${XDG_DATA_HOME:-${HOME}/.local/share}/templates"

chosen=$(echo -e \
"Groff MS
E-Mail
LaTeX
Shell script" | dmenu -b -i -l 20 -p "new")

case $chosen in
    "LaTeX") : ;;
    "Shell script") : ;;
    "Groff MS")
        file=$(mktemp ~/Downloads/newXXX.ms)
        pdf=$(dirname $file)/$(basename $file | cut -d'.' -f 1).pdf
        cp ${templates}/groff_ms $file
        setsid -f st -e $EDITOR $file 
        groff -ms -Tpdf $file > $pdf 
        setsid -f zathura $pdf
        ;;
esac
