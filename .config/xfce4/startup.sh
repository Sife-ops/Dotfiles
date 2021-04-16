#!/bin/sh

gpg --decrypt "${XDG_DATA_HOME}/secrets/dummy.gpg"
offlineimap -c "${XDG_CONFIG_HOME}/offlineimap/offlineimaprc" &
ii_login.sh &
st -e 'tmux' &
st -e 'ssh wyatt@russianbot' &
st -e 'ssh wyatt@soyless.xyz' &
