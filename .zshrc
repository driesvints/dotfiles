# Dotfiles
export DOTFILES="$HOME/.dotfiles"
source $DOTFILES/path.zsh
source $DOTFILES/aliases.zsh

# Theme
export MNML_INSERT_CHAR="$"
export MNML_PROMPT=(mnml_git mnml_keymap)
export MNML_RPROMPT=('mnml_cwd 20')

# Antibody
source $DOTFILES/zsh_plugins.sh