#!/bin/sh

echo "Cloning repositories..."

PROJECTS=$HOME/projects
NEWPROJECT=$PROJECTS/new-project

# Sites
# git clone git@github.com:driesvints/driesvints.com.git $SITES/driesvints.com

# p10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $DOTFILES/powerlevel10k



