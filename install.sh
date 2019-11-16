#!/bin/sh

echo "Setting up your Mac..."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle

# Install global Composer packages
/usr/local/bin/composer global require laravel/installer laravel/valet

# Install Laravel Valet
$HOME/.composer/vendor/bin/valet install

# Create a Sites directory
# This is a default directory for macOS user accounts but doesn't comes pre-installed
mkdir $HOME/Sites

# Register the Sites directory with Valet
cd $HOME/Sites; valet park;

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

# Symlink the Mackup config file to the home directory
ln -s $HOME/.dotfiles/.mackup.cfg $HOME/.mackup.cfg

# Symlink the vim dir to the home directory
ln -s $HOME/.dotfiles/.vim $HOME/.vim

# Symlink the .gitconfig file to the home directory
ln -s $HOME/.dotfiles/.gitconfig $HOME/.gitconfig

echo "Done"
