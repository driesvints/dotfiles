#!/bin/bash

echo "Setting up your Computer..."

if ! [ -d "$HOME/.rvm" ]; then
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
  \curl -sSL https://get.rvm.io | bash -s stable --ruby
fi

if ! [ -d "$HOME/.nvm" ]; then
  \curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
  nvm install 10.7.0
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

# install bash-it
# git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it || echo ".bash_it exists"
ln -s $HOME/.dotfiles/bash_it/themes/powerline-plus $HOME/.bash_it/themes/powerline-plus || echo "powerline-plus exists"


# Update Homebrew recipes
brew update
brew install ansible

pushd ansible-config
ansible-playbook -i "localhost," $USER.yml
popd
# Create a Sites directory
# This is a default directory for macOS user accounts but doesn't comes pre-installed
mkdir $HOME/Sites || echo "Sites exists"

# Set macOS preferences
# We will run this last because this will reload the shell
# . .macos
