# Dries' Dotfiles

Public repository for my personal dotfiles.

## What Is This?

This repository serves as my way to help me setup and maintain my Mac. It takes the effort out of installing everything manually. Everything which is needed to install my preffered setup of OS X is detailed in this readme. Feel free to explore, learn and copy parts for your own dotfiles. Enjoy! :smile:

## A Fresh OS X Setup

Follow these install instructions to setup a new OS X system.

1. Update OS X to the latest version with the App Store
2. Setup OS X with [these preferences](./osx/readme.md)
3. Install Xcode from the App Store, open it and accept the license agreement
4. Install OS X Command Line Tools
5. Copy public and private SSH keys to `~/.ssh`. Make sure they're set to `600`
6. Clone this repo to `~/.dotfiles`
7. Run `./setup.sh` to start the installation
8. Follow the remaining [app installation instructions](./apps/readme.md)

## License

The MIT License. Please see [the license file](license.md) for more information.
