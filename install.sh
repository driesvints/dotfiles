#!/bin/sh

echo "Setting up your Mac..."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

ln -s $HOME/.dotfiles/system/bash_profile $HOME/.bash_profile

# install bash-it
# git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
ln -s $HOME/.dotfiles/bash_it/themes/powerline-plus /home/kevin/.bash_it/themes/powerline-plus


# Update Homebrew recipes
brew update

mkdir $HOME/Projects
cd $HOME/Projects
git clone https://github.com/earlonrails/superlumic-config.git
cd superlumic-config

# Create a Sites directory
# This is a default directory for macOS user accounts but doesn't comes pre-installed
mkdir $HOME/Sites

# Set macOS preferences
# We will run this last because this will reload the shell
. .macos
