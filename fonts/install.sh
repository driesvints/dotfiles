#!/bin/sh

echo "Installing fonts..."

# Installs fonts onto the system.
brew tap caskroom/fonts

fonts=(
  font-source-code-pro
  font-source-sans-pro
  font-source-serif-pro
  font-sauce-code-powerline
)

brew cask install ${fonts[@]}
