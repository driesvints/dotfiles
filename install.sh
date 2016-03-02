#!/bin/sh

echo "Setting up your Mac..."

# Load env variables before we continue
source $HOME/.dotfiles_env

# Install homebrew
source $DOTFILES/homebrew/install.sh

# Restore dependencies through Mackup
brew install mackup
mackup restore

# Install all our dependencies with bundle
brew tap homebrew/bundle
brew bundle

# Install dotfiles on a fresh system
source $DOTFILES/bin/install.sh
source $DOTFILES/zsh/install.sh
source $DOTFILES/php/install.sh
source $DOTFILES/apps/install.sh

# Load ZSH as our environment
env zsh