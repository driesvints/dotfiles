#!/bin/sh

echo "Setting up your Mac..."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

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
