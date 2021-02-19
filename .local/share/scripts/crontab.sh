#!/bin/sh

crontab="/var/spool/cron/$(id -un)"

echo '@hourly export GNUPGHOME=/home/<+home+>/.local/share/gnupg; export SECRETS=/home/<+home+>/.local/share/secrets; /usr/bin/offlineimap -c ~/.config/offlineimap/offlineimaprc
*/1 * * * * export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u $USER)/bus; /home/<+home+>/.local/bin/pacnotifyupdate.sh' \
    > "$crontab"

sed -i "s/<+home+>/$(id -un)/g" "$crontab"
