#!/bin/sh

echo "Setting up your Mac..."

# Load env variables before we continue
source $HOME/.dotfiles_env

# Install dotfiles on a fresh system
source $DOTFILES/bin/setup.sh
source $DOTFILES/homebrew/setup.sh
source $DOTFILES/zsh/setup.sh
source $DOTFILES/osx/setup.sh
source $DOTFILES/php/setup.sh
source $DOTFILES/fonts/setup.sh
source $DOTFILES/apps/setup.sh

# Load ZSH as our environment
env zsh