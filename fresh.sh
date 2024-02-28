#!/bin/sh

echo "Setting up your Mac..."

# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Clone Github repositories
./clone.sh

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -s "$HOME/.dotfiles/.zshrc" "$HOME/.zshrc"

# Power10k shell theme
rm -rf $HOME/.p10k.zsh
ln -s "$HOME/.dotfiles/.p10k.zsh" $HOME/.p10k.zsh

# mackup config
rm -rf $HOME/.mackup.cfg
ln -s "$HOME/.dotfiles/.mackup.cfg" $HOME/.mackup.cfg

# ZSH paths
rm -rf $ZSH_CUSTOM/path.zsh
ln -s "$HOME/.dotfiles/path.zsh" $ZSH_CUSTOM/path.zsh

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle --file ./Brewfile

# thefuck
echo 'eval "$(thefuck --alias)"' >> $HOME/.zprofile

# Set default MySQL root password and auth type
# mysql -u root -e "ALTER USER root@localhost IDENTIFIED WITH mysql_native_password BY 'password'; FLUSH PRIVILEGES;"

# I feel the need, the need for speed.
npm install --global fast-cli

# aliases
ln -s "$HOME/.dotfiles/aliases.zsh" $ZSH/custom/aliases.zsh

# Create a projects directories
mkdir $HOME/projects

# Create Code subdirectories
# mkdir $HOME/projects/subproject-name

# Symlink the Mackup config file to the home directory
ln -s ./.mackup.cfg $HOME/.mackup.cfg

# Set macOS preferences - we will run this last because this will reload the shell
source ./.macos
