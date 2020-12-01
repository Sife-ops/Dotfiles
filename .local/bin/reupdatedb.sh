#!/bin/bash
# create a custom locate database

dbpath="/var/lib/relocate"
prunenames=(".git" ".hg" ".svn")
prunepaths=("/home/wyatt_bu" "/home/wyatt/.cache" "/home/wyatt/.elfeed" "/root" "/proc" "/afs" "/media" "/mnt" "/net" "/sfs" "/sys" "/tmp" "/udev" "/var/cache" "/var/lib/pacman/local" "/var/lock" "/var/run" "/var/spool" "/var/tmp")

[ -d $dbpath ] || mkdir -p $dbpath

for prunename in ${prunenames[@]}; do
    nameargs="$nameargs -not -path '*/\\${prunename}/*'"
done

for prunepath in ${prunepaths[@]}; do
    pathargs="$pathargs -path '$prunepath' -prune -o"
done

eval find / $pathargs $nameargs -type f -print | tee ${dbpath}/relocatef.db
eval find / $pathargs $nameargs -type d -print | tee ${dbpath}/relocated.db

# additional paths
find /mnt/wyatt/sda1/Downloads -type d -print | tee -a ${dbpath}/relocated.db
find /mnt/wyatt/sda1/Downloads -type f -print | tee -a ${dbpath}/relocatef.db
find /mnt/wyatt/russianbot/Documents -type d -print \
    | tee -a ${dbpath}/relocated.db
find /mnt/wyatt/russianbot/Documents -type f -print \
    | tee -a ${dbpath}/relocatef.db

chmod +r ${dbpath}/relocatef.db
chmod +r ${dbpath}/relocated.db
