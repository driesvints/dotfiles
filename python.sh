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

if ! grep -q 'eval "$(pyenv virtualenv-init -)"' ~/.zshrc; then
  echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "installing pipx to help install & run end-user applications"
brew install pipx
pipx ensurepath

echo "installing pipenv"
pipx install pipenv
pipx ensurepath

echo 'installing the following pyenv versions: 3.10.2, anaconda3-2021.11'
pyenv install 3.10.2
pyenv install anaconda3-2021.11

echo 'running brew cleanup; brew doctor'
brew cleanup
brew doctor

echo 'Finished installing pyenv. Double check that pyenv was injected in zprofile and zshrc.'