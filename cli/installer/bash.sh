#!/bin/sh

mv ${HOME}/.bashrc ~/.bashrc_
touch ${HOME}/.bashrc-override

stow bash

