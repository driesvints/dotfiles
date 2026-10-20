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

### sdkman setter Java_home automagisk
### export JAVA_HOME="$(/usr/libexec/java_home)"
export MAVEN_HOME=$HOME/bin/apache-maven-3.6.3
##export POSTGRES_HOME=/Applications/Postgres.app/Contents/Versions/latest

# Maven settings
## 19.01.2024 removed -XX:MaxPermSize=size is removed from Java17 
##export MAVEN_OPTS="-Xmx1024M -XX:MaxPermSize=1024m -Dfile.encoding=UTF-8"
export MAVEN_OPTS=
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

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
####. "/usr/local/opt/nvm/nvm.sh"

# jenv (installed with brew
###export PATH="$HOME/.jenv/bin:$PATH"
#eval "$(jenv init -)"
#if which jenv > /dev/null; then eval "$(jenv init -)"; fi

## oppdater token i NODE_AUTH_TOKEN 
## npm klarer å bruke .npmrc, men bun trenger NODE_AUTH_TOKEN
export NODE_AUTH_TOKEN=$(sed -n '2p' .npmrc | awk -F "_authToken=" '{print $2}')

# openssl 
#--------
# Set openssl first on PATH
export PATH="/usr/local/opt/openssl/bin:$PATH"
#For compilers to find openssl, let's export:
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"
# For pkg-config to find openssl, let's set:
export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig"

# Enable 'kube-ps1'
PROMPT=$PROMPT'$(kube_ps1) '
# On Bekk Mac:
###kubeoff

echo "[DEBUG] TODO: Android "
# Android emulator
#export PATH=$PATH:/usr/local/share/android-commandlinetools/emulator/
##export ANDROID_SDK_ROOT=/usr/local/share/android-commandlinetools
#export ANDROID_SDK_ROOT=~/Library/Android/sdk

# install mac 2024
# path to pre-installed brew
export BREW_PATH=/opt/homebrew/bin
export PATH="$BREW_PATH:$PATH"

# install GPG: https://gist.github.com/troyfontaine/18c9146295168ee9ca2b30c00bd1b41e 
export GPG_TTY=$(tty)

# Gcloud CLI - ref: https://cloud.google.com/sdk/docs/install
export GCLOUD_CLI_PATH="$HOME/bin/google-cloud-sdk/bin"
export PATH="$GCLOUD_CLI_PATH:$PATH"
## installed by Gcloud install.sh
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/thomas/bin/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/thomas/bin/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/thomas/bin/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/thomas/bin/google-cloud-sdk/completion.zsh.inc'; fi

# miscellanous
#-------------
# the following makes it possible to comment a command-line, just like bash
setopt interactivecomments
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
# Docker/Colima
# To avoid following after 'docker ps': Error response from daemon: client version 1.52 is too new. Maximum supported API version is 1.43
export DOCKER_API_VERSION=1.43

# Python
#--------
# pyenv (brew) for managing python versions
# pyenv-virtualenv (brew) for managing python versions + venv (brew)
# see: https://github.com/pyenv/pyenv-virtualenv 
# pyenv init
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
# OBS: symlink from /opt/homebrew/bin/pyenv-virtualenv 
export PATH="/opt/homebrew/Cellar/pyenv-virtualenv/1.2.6/shims:${PATH}";
export PYENV_VIRTUALENV_INIT=1;
_pyenv_virtualenv_hook() {
  local ret=$?
  if [ -n "${VIRTUAL_ENV-}" ]; then
    eval "$(pyenv sh-activate --quiet || pyenv sh-deactivate --quiet || true)" || true
  else
    eval "$(pyenv sh-activate --quiet || true)" || true
  fi
  return $ret
};
typeset -g -a precmd_functions
if [[ -z $precmd_functions[(r)_pyenv_virtualenv_hook] ]]; then
  precmd_functions=(_pyenv_virtualenv_hook $precmd_functions);
fi
#eval "$(pyenv virtualenv-init -)"

