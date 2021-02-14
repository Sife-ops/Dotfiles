#!/bin/sh

pacman="$(mktemp pacman.XXX)"
aur="$(mktemp aur.XXX)"

pacman -Qqen > "$pacman"
pacman -Qqem > "$aur"

echo "#TAG,NAME IN REPO (or git url),PURPOSE (should be a verb phrase to sound right while installing)" > progs.csv
while read line; do
    echo ",${line},\"<++>\"" >> progs.csv
done < "$pacman"

while read line; do
    echo "A,${line},\"<++>\"" >> progs.csv
done < "$aur"

rm -rf "$pacman"
rm -rf "$aur"
