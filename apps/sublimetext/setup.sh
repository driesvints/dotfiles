#!/usr/bin/env bash

echo "Setting up Sublime Text 3..."

# Make sure library directory exists
mkdir -p ~/Library/Application\ Support/Sublime\ Text\ 3/Packages
mkdir -p ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages

# Symlink user preferences
ln -s ~/.dotfiles/apps/sublimetext/preferences/ ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User

# Install Package Control
curl -o ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/Package\ Control.sublime-package https://packagecontrol.io/Package\ Control.sublime-package
