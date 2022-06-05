#!/bin/sh

echo "Do you want to install lf r27? [y/n]"
read choice
if [ ${choice:-'n'} = 'y' ] ; then
    install_lf
fi
stow lf

