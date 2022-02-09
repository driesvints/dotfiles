echo 'installing pyenv and configuring to use with zsh'
# Check if pyenv is installed and install if we don't have it
if test ! $(which pyenv); then
    brew install pyenv
fi


if ! grep -q 'eval "$(pyenv init --path)"' ~/.zprofile; then
  echo 'eval "$(pyenv init --path)"' >> ~/.zprofile
fi

if ! grep -q 'eval "$(pyenv init -)"' ~/.zshrc; then
  echo 'eval "$(pyenv init -)"' >> ~/.zshrc
fi

echo 'Finished installing pyenv. Double check that pyenv was injected in zprofile and zshrc.'