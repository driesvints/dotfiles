## Set ZSH_DEBUG to ON/OFF
export ZSH_DEBUG="OFF"

if [[ "$ZSH_DEBUG" == "ON" ]]; then echo "[DEBUG] debug mode is on"; fi

if [[ "$ZSH_DEBUG" == "ON" ]]; then echo " "; fi
if [[ "$ZSH_DEBUG" == "ON" ]]; then echo "[DEBUG] initializing .zshrc"; fi

# Path to your dotfiles installation.
export DOTFILES=$HOME/.dotfiles

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="kolo"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd/mm/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$DOTFILES

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(composer git git-extras httpie github npm sublime vagrant kubectl kube-ps1)

# Environment variables
if [[ "$ZSH_DEBUG" == "ON" ]]; then echo "[DEBUG] setting up some environment variables"; fi
#export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"
#export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-11.0.2.jdk/Contents/Home"
export JAVA_HOME="$(/usr/libexec/java_home)"
export MAVEN_HOME=$HOME/bin/apache-maven-3.6.3
export POSTGRES_HOME=/Applications/Postgres.app/Contents/Versions/latest

# Maven settings
export MAVEN_OPTS="-Xmx1024M -XX:MaxPermSize=1024m -Dfile.encoding=UTF-8"
### debug ###MAVEN_OPTS="$MAVEN_OPTS -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005"
export M2_REPO=$HOME/.m2/repository


# Activate Oh-My-Zsh
if [[ "$ZSH_DEBUG" == "ON" ]]; then echo "[DEBUG] activating Oh My Zsh!"; fi
source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
##export LC_ALL=en_US.UTF-8
##export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

#export NVM_DIR="$HOME/.nvm"
#  . "/usr/local/opt/nvm/nvm.sh"

# jenv (installed with brew
export PATH="$HOME/.jenv/bin:$PATH"
#eval "$(jenv init -)"
#if which jenv > /dev/null; then eval "$(jenv init -)"; fi

# openssl 
#--------
# Set openssl first on PATH
export PATH="/usr/local/opt/openssl/bin:$PATH"
#For compilers to find openssl, let's export:
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"
# For pkg-config to find openssl, let's set:
export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig"

# kubectl (NAV) 
#---------------
export KUBECONFIG="/Users/thomasdufourd/Code/nav/kubeconfigs/config"

# Vault (NAV)
# -----------
#export VAULT_ADDR="https://vault.adeo.no" 
export VAULT_ADDR="http://localhost:8200"

# Enable 'kube-ps1'
PROMPT=$PROMPT'$(kube_ps1) '
# On Bekk Mac:
kubeoff

# Flutter https://flutter.dev/docs/get-started/install/macos 
export FLUTTER_BIN="/Users/thomasdufourd/bin/flutter/bin"
export PATH="$FLUTTER_BIN:$PATH"

# jenv
# SEE: https://medium.com/@chamikakasun/how-to-manage-multiple-java-version-in-macos-e5421345f6d0 
# find all java versions installed:  /usr/libexec/java_home -V
# add new jdk to jenv: jenv add <your_jdk_path>
# list: jenv versions
# use: jenv global 14.0
# or (project): jenv local 11
#  ensure that JAVA_HOME is correct
# ->jenv enable-plugin export
# make Maven aware of the Java version in use (and switch when your project does)
# ->jenv enable-plugin maven
 export PATH="$HOME/.jenv/bin:$PATH"
 eval "$(jenv init -)"

# Android emulator
export PATH=$PATH:/usr/local/share/android-commandlinetools/emulator/
##export ANDROID_SDK_ROOT=/usr/local/share/android-commandlinetools
export ANDROID_SDK_ROOT=~/Library/Android/sdk

# miscellanous
#-------------
# the following makes it possible to comment a command-line, just like bash
setopt interactivecomments
