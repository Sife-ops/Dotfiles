#!/bin/sh
fdsa="$(git branch --show-current)"
git stash
git checkout master
git pull
git checkout "$fdsa"
git merge master
git stash apply
