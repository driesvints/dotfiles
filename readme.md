# Dries' Dotfiles

Public repository for my personal dotfiles.

## Setup new OS X

Follow these install instructions to setup a new OS X system.

1. Setup OS X with the preferences below. Make sure you update OS X to the latest version with the App Store
2. Install Xcode with the App Store, open it and accept the license agreement
3. Install OS X Command Line Tools
4. Copy public and private SSH keys to `~/.ssh`. Make sure they're set to `600`
5. Clone this repo to `~/.dotfiles`
6. Run `./setup.sh` to install preferences & applications
7. Install remaining applications from the App Store

### Preferences

Checklist to setup OS X with my personal preferences.

- General -> Auto hide menu bar
- General -> Dark menu bar and dock
- Dock -> Auto hide dock
- Mission Control -> Hot Corners
- Mission Control -> Group windows by application
- Date & Time -> Use 24 hour clock
- Date & Time -> Show date
- Sharing -> Adjust Computer Name

### Applications

Most applications get installed through Homebrew Cask. The remaining ones need to be installed from the app store:

- 1Password
- Sketch 2
- Paw
- Wunderlist
- Tweetbot
- Byword

