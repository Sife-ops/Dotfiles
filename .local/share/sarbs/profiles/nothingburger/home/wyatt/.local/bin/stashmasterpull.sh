#!/bin/sh
branch="$(git branch --show-current)"
git stash
git checkout master
git pull
git checkout "$branch"
git merge master
git stash apply
