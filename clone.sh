#!/bin/sh

echo "Cloning repositories..."

WORK=$HOME/Workspace

#Should already be cloned
#git clone git@github.com:deepakv158/.dotfiles.git ~/.dotfiles

#Utilities
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $WORK/zsh-autocomplete

# Personal

# Work repos
git clone ssh://git@bitbucket.oci.oraclecorp.com:7999/SECEDGE/ssh_configs.git $WORK/ssh_configs
