#!/bin/sh

gpg --decrypt "${XDG_DATA_HOME}/secrets/dummy.gpg"
offlineimap -c "${XDG_CONFIG_HOME}/offlineimap/offlineimaprc" &
ii_login.sh &
