#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

# dotfiles directory
dir=$(pwd)

# old dotfiles backup directory
olddir=$(pwd)/dotfiles_old

# list of files/folders to symlink in homedir
files="aliases bash_profile bashrc condarc curlrc dots editorconfig exports extra functions gdbinit gitattributes gitconfig gitignore gvimrc hgignore profile vimrc wgetrc zshenv zshrc"

##########

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
    echo "Moving any existing dotfiles from ~/.$file to $olddir"
    mv ~/.$file $olddir/
    echo `ln -sv $dir/$file ~/.$file`
	ln -sv $dir/$file ~/.$file
	echo "------------------------"
done
