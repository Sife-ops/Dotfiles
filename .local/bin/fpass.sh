#!/bin/bash
# fzf wrapper for bitwarden-cli

if which checkdeps.sh >/dev/null 2>&1; then
    checkdeps.sh bw fzf jq xclip || exit 1; fi

msg_help() { echo \
"Usage:
    fpass.sh [OPTIONS]

Options:
    -l              loop forever
    -h              print this message"
}

while getopts "lh" o; do case "${o}" in
    l) LOOP="true" ;;
    h) msg_help && exit 0 ;;
	*) printf "Invalid option: -%s\\n" "$o" && msg_help && exit 1 ;;
esac done
shift $((OPTIND - 1))

sessionkey=$(bw unlock \
    | grep 'export' \
    | sed 's/\(^.*BW_SESSION="\)\(.*\)\("\)/\2/')

while true; do
    passwd=$(bw get item --session "$sessionkey" \
        "$(bw list items --session "$sessionkey" |
            jq '.[] | "\(.name) | username: \(.login.username) | id: \(.id)" ' |
            fzf |
            awk '{print $(NF -0)}' |
            sed 's/\"//g')" |
        jq '.login.password' |
        sed 's/\"//g' |
        tr -d '\n')

    echo $passwd | xclip -selection clipboard 2>/dev/null
    echo $passwd

    [ "$LOOP" == "true" ] \
        || break;

done
