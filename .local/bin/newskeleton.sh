#!/bin/sh

tmp=$(mktemp /tmp/newskel_XXXXXX)
printf "example-<++>" > $tmp
$EDITOR $tmp
grep "<++>" $tmp && exit 1
name=$(cat $tmp)
printf "if (<++>) {\n\t<++>\n}" > $tmp
$EDITOR $tmp
mv $tmp "${XDG_DATA_HOME}/skeletons/${name}"
