#!/bin/sh

crontab="/var/spool/cron/$(id -un)"

echo '@hourly export GNUPGHOME=/home/<+home+>/.local/share/gnupg; export SECRETS=/home/<+home+>/.local/share/secrets; /usr/bin/offlineimap -c ~/.config/offlineimap/offlineimaprc' \
    > "$crontab"

sed -i "s/<+home+>/$(id -un)/g" "$crontab"
