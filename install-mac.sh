#!/bin/bash

# Check for Homebrew and install if we don't have it
if ! [ -x "$(command -v brew)" ]; then
  xcode-select --install
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  ln -s $HOME/.dotfiles/git/gitconfig.work $HOME/.gitconfig || echo ".gitconfig exists"
fi

brew update
brew bundle

# Set macOS preferences
# We will run this last because this will reload the shell
if [ "$(uname)" == "Darwin" ]; then
  source .macos
fi
