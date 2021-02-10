#!/bin/sh
# manage clipboards
# todo:
# implement new/delete clipboard
# "clear all"

. menu.sh

main_list="$(echo "clipboard: $(clipboard put | head -n1)")
$(echo "primary: $(clipboard put primary | head -n1)")
$(echo "secondary: $(clipboard put secondary | head -n1)")
$(for file in $(find ${clipboard}/ -type f); do
    echo "$(basename "$clipboard")/"$(basename "$file")": $(head -n1 "$file")"
done | sort)"

choose "$main_list" "from"
chosen="$(echo "$chosen" | cut -d ':' -f 1)"
case "$chosen" in
    clipboard/*) cmd="cat ${clipboard}/$(basename "$chosen")" ;;
    clipboard) cmd="clipboard put" ;;
    primary) cmd="clipboard put primary" ;;
    secondary) cmd="clipboard put secondary" ;;
    "") exit 1 ;;
    *) exit 1 ;;
esac

choose "$main_list" "to"
chosen="$(echo "$chosen" | cut -d ':' -f 1)"
case "$chosen" in
    clipboard/*) $cmd > ${clipboard}/$(basename "$chosen") ;;
    clipboard) clipboard yank "$($cmd)" ;;
    primary) clipboard yank "$($cmd)" primary ;;
    secondary) clipboard yank "$($cmd)" secondary ;;
    "") exit 1 ;;
    *) exit 1 ;;
esac
