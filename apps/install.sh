#!/bin/sh

echo "Setting up apps..."

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
  google-drive
  vagrant
  sublime-text3
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
brew cask install --appdir="/Applications" ${apps[@]}

# Setup applications
echo "Setting up apps..."
source ./alfred/setup.sh
source ./phpstorm/setup.sh
source ./sublimetext/setup.sh
