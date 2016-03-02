#!/bin/sh

echo "Setting up apps..."

# Setup PhpStorm
# source $DOTFILES/apps/phpstorm/install.sh

# Install Package Control for Sublime Text 3
mkdir -p $LIBRARY/Application\ Support/Sublime\ Text\ 3/Installed\ Packages
curl -o $LIBRARY/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/Package\ Control.sublime-package https://packagecontrol.io/Package\ Control.sublime-package

# Symlink PhpStorm Themes
mkdir -p $LIBRARY/Preferences/WebIde100/colors
ln -s $DOTFILES/app/phpstorm/themes/Material\ Peacock\ Custom.icls $LIBRARY/Preferences/WebIde100/colors/Material\ Peacock\ Custom.icls

