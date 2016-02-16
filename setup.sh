#!/usr/bin/env bash

echo "Setting up your Mac..."

# Load settings before we continue
source ./.settings

# Install dotfiles on a fresh system
source $DOTFILES/bin/setup.sh
source $DOTFILES/homebrew/setup.sh
source $DOTFILES/osx/setup.sh
source $DOTFILES/php/setup.sh
source $DOTFILES/fonts/setup.sh
source $DOTFILES/apps/setup.sh

# Link dotfiles
ln -s $DOTFILES/.bash_profile $HOME/.bash_profile