#!/bin/sh

echo "Setting up your Mac..."

# Load env variables before we continue
source $HOME/.dotfiles_env

# Install homebrew
source $DOTFILES/homebrew/install.sh

# Install all our dependencies with bundle
brew tap homebrew/bundle
brew bundle

# Install everything else
source $DOTFILES/zsh/install.sh
source $DOTFILES/php/install.sh
source $DOTFILES/apps/install.sh