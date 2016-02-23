#!/bin/sh

echo "Setting up Oh-My-Zsh..."

# Symlink .zshrc file
rm $HOME/.zshrc
ln -s $DOTFILES/zsh/.zshrc $HOME/.zshrc

# Reload the environment
env zsh