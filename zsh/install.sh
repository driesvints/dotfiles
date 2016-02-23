#!/bin/sh

echo "Setting up zsh..."

# Install zsh
brew install zsh zsh-completions

# Make zsh the default environment
chsh -s $(which zsh)
