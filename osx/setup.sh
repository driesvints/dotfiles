#!/usr/bin/env bash

echo "Setting up OS X..."

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install Bash 4
brew install bash

# Install more recent versions of some OS X tools
brew tap homebrew/dupes
brew install homebrew/dupes/grep

# Install Binaries
binaries=(
  trash
  node
  tree
  hub
  git
  caskroom/cask/brew-cask
  caskroom/versions
)

brew install ${binaries[@]}

# Cleanup brew installs
brew cleanup

# Set preferences
source ./preferences.sh