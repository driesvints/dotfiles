#!/bin/sh

echo "Setting up zsh..."

# Install zsh
brew install zsh zsh-completions

# Symlink .zshrc file
ln -s $DOTFILES/zsh/.zshrc $HOME/.zshrc

# Make zsh the default environment
chsh -s $(which zsh)
