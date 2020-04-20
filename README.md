# @tunaranch's Dotfiles

Dotfiles and system configuration to get a MacOS system the way tunaranch likes it.

## A Fresh macOS Setup

Clone this repo to `~/.dotfiles` and run `install.sh`.

This will bootstrap enough Homebrew to run ansible, and will use ansible
to set up the rest. See [the setup playbook](./ansible/setup.playbook.yml).  

### Before you re-install

The Ansible play is idempotent and non-destructive, so knock youself out.


### Setting up your Mac

If you did all the above you may now follow these install instructions to set up a new Mac.

1. Update macOS to the latest version with the App Store
2. Install Xcode from the App Store, open it and accept the license agreement
3. Install macOS Command Line Tools by running `xcode-select --install`
4. [Generate a new public and private SSH key](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) and add them to Github
5. Clone this repo to `~/.dotfiles`
6. Run `install.sh` to start the installation


Your Mac is now ready to use!

## Thanks To...

This repo is a fork of [driesvints/dotfiles](https://github.com/driesvints/dotfiles), but
the guts have been replaced with ansible.