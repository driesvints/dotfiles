#!/bin/sh

echo "Setting up your Mac..."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle
brew tap homebrew/bundle
brew bundle

# Make zsh the default environment
chsh -s $(which zsh)

# Install Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Install global packages
/usr/local/bin/composer global require laravel/installer laravel/lumen-installer

# Create a Sites directory
mkdir ~/Sites

# Set OS X preferences
source .osx