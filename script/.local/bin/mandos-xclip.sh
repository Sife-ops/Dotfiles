#!/bin/sh

login=$(mandos)

echo $login | jq -r '.username' | xclip -i -selection primary
echo $login | jq -r '.password' | xclip -i -selection clipboard
