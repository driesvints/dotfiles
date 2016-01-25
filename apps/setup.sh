#!/usr/bin/env bash

# Install OS X Applications
apps=(
  goofy
  slack
  phpstorm
  iterm2
  sequel-pro
  alfred
  transmit
  mysqlworkbench
  dropbox
  virtualbox
  virtualbox-extension-pack
  vagrant
  sublime-text
  tower
  textual
  skype
  firefox
  vlc
  screenhero
  evernote
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing apps..."
brew cask install --appdir="/Applications" ${apps[@]}

# Setup applications
source ./alfred/setup.sh
source ./phpstorm/setup.sh

