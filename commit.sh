#!/usr/bin/env bash

git pull
homesick symlink dotfiles
vim +PluginInstall +qall
cd .
git add -A .
git commit -m "Updates dotfiles"
git push

