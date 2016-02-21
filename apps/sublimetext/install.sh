#!/bin/sh

echo "Setting up Sublime Text 3..."

# Make sure library directory exists
mkdir -p $LIBRARY/Application\ Support/Sublime\ Text\ 3/Packages
mkdir -p $LIBRARY/Application\ Support/Sublime\ Text\ 3/Installed\ Packages

# Symlink user preferences
ln -s $DOTFILES/apps/sublimetext/preferences $LIBRARY/Application\ Support/Sublime\ Text\ 3/Packages/User

# Install Package Control
curl -o $LIBRARY/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/Package\ Control.sublime-package https://packagecontrol.io/Package\ Control.sublime-package
