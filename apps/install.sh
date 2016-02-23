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
source $DOTFILES/apps/alfred/install.sh
source $DOTFILES/apps/iterm2/install.sh
source $DOTFILES/apps/phpstorm/install.sh
source $DOTFILES/apps/sublimetext/install.sh
