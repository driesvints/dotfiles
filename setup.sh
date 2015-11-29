# Install dotfiles on a fresh system

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install Bash 4
brew install bash

# Install more recent versions of some OS X tools
brew tap homebrew/dupes
brew install homebrew/dupes/grep

# Install Binaries

binaries=(
  trash
  node
  tree
  hub
  git
  caskroom/cask/brew-cask
)

echo "installing binaries..."
brew install ${binaries[@]}

brew cleanup

# Install OS X Applications
apps=(
  google-chrome
  goofy
  slack
  phpstorm
  iterm2
  sequel-pro
  alfred
  transmit
  mysqlworkbench
  dropbox
  virtualbox
  virtualbox-extension-pack
  vagrant
  sublime-text
  tower
  textual
  skype
  firefox
  vlc
  screenhero
  evernote
)


# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing apps..."
brew cask install --appdir="/Applications" ${apps[@]}

# Link Alfread
brew cask alfred link

# Install Fonts
brew tap caskroom/fonts

# fonts
fonts=(
  font-source-code-pro
  font-source-sans-pro
  font-source-serif-pro
)

# install fonts
echo "installing fonts..."
brew cask install ${fonts[@]}


