export DOTFILES=$HOME/.dotfiles
export ZPLUG_HOME=/usr/local/opt/zplug

source $ZPLUG_HOME/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# Plugins
zplug "~/.dotfiles", from:local

zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3

# Themes
export MNML_INSERT_CHAR="$"
export MNML_PROMPT=(mnml_status mnml_git mnml_keymap)
export MNML_RPROMPT=('mnml_cwd 20')

zplug subnixr/minimal, use:minimal.zsh, from:github, as:theme

zplug load