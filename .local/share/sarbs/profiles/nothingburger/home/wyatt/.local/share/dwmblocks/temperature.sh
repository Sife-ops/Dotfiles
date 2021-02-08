#!/bin/sh
# print CPU temperature (for 2007 Macbook)

re='^[0-9]+$'
sensors=$(sensors 2>/dev/null | grep 'TC0D' | sed -u 's/\(.*+\)\(.*\)/\2/' | tr -d "[:space:]")
if [[ ${sensors:0:1} =~ $re  ]] ; then
    temp=$sensors
else
    temp="NA"
fi
icon="🌡"
printf "%s%s\\n" "$icon" "$temp"
