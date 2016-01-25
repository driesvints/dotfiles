#!/usr/bin/env bash

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
)

echo "installing binaries..."
brew install ${binaries[@]}

brew cleanup