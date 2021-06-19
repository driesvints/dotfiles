#!/bin/bash

# echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# https://ubuntu.pkgs.org/16.04/ubuntu-universe-amd64/caffeine_2.8.3-3build1_all.deb.html

# http://c7be0123d7efff32860a-a5a4fb8b39b86d00a1eb7d52603ae1d2.r6.cf1.rackcdn.com/vpn-unlimited_4.22-amd64_001_release_STANDALONE.deb

# https://github.com/sqlectron/sqlectron-gui/releases/download/v1.29.0/Sqlectron_1.29.0_amd64.deb

# http://freelinuxtutorials.com/quick-tips-and-tricks/quick-tip-install-fingerprint-scanner-fprint-ubuntu-16-04-linux/

# https://steamcdn-a.akamaihd.net/client/installer/steam.deb

# http://download.virtualbox.org/virtualbox/5.2.12/virtualbox-5.2_5.2.12-122591~Ubuntu~xenial_amd64.deb

sudo apt install -y automake \
	bash-completion \
	cmake \
	coreutils \
	fish \
	gnupg \
	htop \
	jq \
	progress \
	redis \
	tmux \
	alfred \
	android-studio \
	google-chrome \
	firefox \
	gimp \
	meld \
	rowanj-gitx \
	steam \
	sublime-text \
	virtualbox \
	vlc \
	apt-transport-https \
  ca-certificates \
	curl \
  software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
    "deb https://download.docker.com/linux/ubuntu xenial stable"
sudo apt update -y
sudo apt install -y docker-ce docker-compose
sudo gpasswd -a "${USER}" docker


