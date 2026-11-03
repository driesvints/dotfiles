#!/bin/bash

echo "Setting up your Mac..."

# Check if Xcode Command Line Tools are installed
if ! xcode-select -p >/dev/null 2>&1; then
  echo "Xcode Command Line Tools not found. Installing..."
  xcode-select --install
else
  echo "Xcode Command Line Tools already installed."
fi

# Check for Oh My Zsh and install if we don't have it
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# Check for Homebrew and install if we don't have it
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf "$HOME/.zshrc"
ln -sw "$HOME/.dotfiles/.zshrc" "$HOME/.zshrc"

# Removes the global CLAUDE.md from $HOME (if it exists) and symlinks the one from the .dotfiles
mkdir -p "$HOME/.claude"
rm -rf "$HOME/.claude/CLAUDE.md"
ln -s "$HOME/.dotfiles/ai/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

# Install the versioned Git and SSH configuration.
"$HOME/.dotfiles/install-configs.sh"

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew bundle --file ./Brewfile
