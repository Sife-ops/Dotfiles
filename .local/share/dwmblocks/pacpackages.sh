#!/bin/sh
# print number of upgraded packages

pacman -Qu | grep -Fcv "[ignored]" | sed "s/^/📦/;s/^📦0$//g"
