#!/bin/sh

echo "Setting up your Mac..."

# Bootstrap homebrew if needed
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew update
  brew tap homebrew/bundle
  brew bundle
  brew install poetry
fi

poetry install
poetry run ansible-playbook ansible/setup.playbook.yml

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc
