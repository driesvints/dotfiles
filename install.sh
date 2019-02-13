#!/bin/bash

echo "Setting up your Computer..."

if ! [ -d "$HOME/.asdf" ]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.6.3
fi

# Check for Homebrew and install if we don't have it
if ! [ -x "$(command -v brew)" ]; then
  if [ "$(uname)" == "Darwin" ]; then
    xcode-select --install
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    ln -s $HOME/.dotfiles/git/gitconfig.work $HOME/.gitconfig || echo ".gitconfig exists"
  else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    sudo apt install linuxbrew-wrapper
  fi
fi

ln -s $HOME/.dotfiles/git/gitignore_global $HOME/.gitignore_global || echo ".gitignore_global exists"
ln -s $HOME/.dotfiles/git/git-hooks $HOME/.git-hooks || echo ".git-hooks exists"
ln -s $HOME/.dotfiles/fish $HOME/.config/fish || echo "fish config exists"
ln -s $HOME/.dotfiles/system/bash_profile $HOME/.bash_profile || echo ".bash_profile exists"
ln -s $HOME/.dotfiles/Sublime\ Text\ 3/Preferences.sublime-settings $HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Preferences.sublime-settings || echo "Sublime Preferences exists"
ln -s $HOME/.dotfiles/iterm/profile $HOME/Library/Preferences/com.googlecode.iterm2.plist || echo "iterm profile exists"

# install bash-it
# git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it || echo ".bash_it exists"
ln -s $HOME/.dotfiles/bash_it/themes/powerline-plus $HOME/.bash_it/themes/powerline-plus || echo "powerline-plus exists"

# Update Homebrew recipes
brew update
if [ "$(uname)" == "Darwin" ]; then
  brew bundle
else
  brew bundle --file Brewfile.linux
fi
# Create a Sites directory
# This is a default directory for macOS user accounts but doesn't comes pre-installed
mkdir $HOME/Sites || echo "Sites exists"

# Set macOS preferences
# We will run this last because this will reload the shell
if [ "$(uname)" == "Darwin" ]; then
  source .macos
fi
source $HOME/.bash_profile
