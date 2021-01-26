#!/bin/bash
# create a custom locate database

#^ setup
dbpath="/var/lib/relocate"
[ -d $dbpath ] || mkdir -p $dbpath
#$

prunenames=( #^
".git"
".hg"
".svn"
) #$

prunepaths=( #^
"/home/wyatt/.cache"
"/home/wyatt/.elfeed"
"/root"
"/proc"
"/afs"
"/media"
"/mnt"
"/net"
"/sfs"
"/sys"
"/tmp"
"/udev"
"/var/cache"
"/var/lib/pacman/local"
"/var/lock"
"/var/run"
"/var/spool"
"/var/tmp"
) #$

for prunename in "${prunenames[@]}"; do #^
    nameargs="$nameargs -not -path '*/\\${prunename}/*'"
done
for prunepath in "${prunepaths[@]}"; do
    pathargs="$pathargs -path '$prunepath' -prune -o"
done #$

#^ main
eval find / "$pathargs" "$nameargs" -type f -print | tee ${dbpath}/relocatef.db
eval find / "$pathargs" "$nameargs" -type d -print | tee ${dbpath}/relocated.db

chmod +r ${dbpath}/relocatef.db
chmod +r ${dbpath}/relocated.db
#$

# vim: fdm=marker fmr=#^,#$
