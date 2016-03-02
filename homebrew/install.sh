#!/bin/sh

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  echo "Seting up Homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
brew update
