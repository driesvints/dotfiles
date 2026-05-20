## OMZ CONFIGURATION

# Path to your dotfiles installation.
export DOTFILES="${HOME}/.dotfiles"

# If you come from bash you might have to change your $PATH.
export PATH="${DOTFILES}/bin:${PATH}"

# Re-prepend mise shims after PATH reset so they come before /usr/bin.
# path_helper (macOS) and .zshrc's hardcoded PATH push shims back behind /usr/bin;
# mise exec inserts tool bins relative to shim position, so shims must lead.
export PATH="${HOME}/.local/share/mise/shims:${PATH}"

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=$DOTFILES

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# See https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/
plugins=(
  # Runtimes and auto-completions
  brew
  # iterm2
  # ngrok
  zsh-autosuggestions
  zsh-completions

  common-aliases               # creates helpful shortcut aliases for many commonly used commands
  # encode64                     # encode64/e64; encodefile64/ef64; decode64/d64
  history                      # h (history); hl (less); hs (grep); hsi (grep -i)
  # jsontools                    # <json data> | <tool>: pp_json; is_json; urlencode_json; urldecode_json
  zbell                        # prints a bell character when a command finishes if it has been running for longer than a specified duration
  zsh-history-substring-search # type in part of prev entered command and cycle with UP/DOWN arrow keys
)

# User configuration for oh-my-zsh and plugins
DEFAULT_USER="chrisbloom7"

# Activate mise before OMZ loads so plugins can use mise-managed tools
[[ -n "$(command -v mise 2>/dev/null)" ]] && eval "$(mise activate zsh)" || true

# Docker CLI completions must be added to fpath before compinit (called by OMZ)
fpath=("${HOME}/.docker/completions" $fpath)

# Initialize oh-my-zsh
[[ ! -f $ZSH/oh-my-zsh.sh ]] && echo "oh-my-zsh not found at $ZSH" && exit 1
source $ZSH/oh-my-zsh.sh

## USER CONFIGURATION

# You may need to manually set your language environment
export LC_ALL="${LC_ALL:-en_US.UTF-8}"
export LANG="${LANG:-en_US.UTF-8}"

# Preferred editor for local and remote sessions
_DEFAULT_EDITOR=
if [[ -n $(command -v ox 2>/dev/null) ]]; then
  _DEFAULT_EDITOR=ox
fi
if [[ -z $SSH_CONNECTION ]]; then
  if [[ -n $(command -v cursor 2>/dev/null) ]]; then
    _DEFAULT_EDITOR=cursor
  elif [[ -n $(command -v code 2>/dev/null) ]]; then
    _DEFAULT_EDITOR=code
  fi
fi
export EDITOR="${EDITOR:-${_DEFAULT_EDITOR}}"
export GIT_EDITOR="${GIT_EDITOR:-${EDITOR} --wait}"
unset _DEFAULT_EDITOR

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Ensure AWS defaults are set
export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-us-east-1}"

# Always show progress on Docker builds
export BUILDKIT_PROGRESS=plain

# Load project aliases (backed up by Mackup to prevent leaking sensitive info)
test -e "${HOME}/.aliases" && source "${HOME}/.aliases"

# Other completions added by installed tools
test -e "${HOME}/.hunt-cli/autocomplete_zsh" && source "${HOME}/.hunt-cli/autocomplete_zsh"
if test -e "${HOME}/.config/op/plugins.sh"; then
  source "${HOME}/.config/op/plugins.sh"
  unalias gh 2>/dev/null || true  # gh uses its own auth via `gh auth login`
fi
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
test -e "${HOME}/.stripe-completion.zsh" && source "${HOME}/.stripe-completion.zsh"

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi

# Root Loops (https://rootloops.sh?sugar=7&colors=6&sogginess=4&flavor=1&fruit=10&milk=0)
export FZF_DEFAULT_OPTS="  --color=fg:#f4f2f9,fg+:#e5dff1,bg:#07040d,bg+:#261d35 \
  --color=hl:#52a9a9,hl+:#63c0bf,info:#bc904f,marker:#7aa860 \
  --color=prompt:#d97780,spinner:#b77ed1,pointer:#b77ed1,header:#6b9bd9 \
  --color=border:#584875,label:#b2a2d1,query:#f4f2f9"
eval "$(fzf --zsh)"

# Mark this as an interactive shell session for Claude Code hooks (e.g. stop notifications).
export CLAUDE_NOTIFY=1

# Auto-attach to (or create) a default tmux session when opening a terminal.
# Comment out if sharing the same session across Warp tabs feels wrong.
# if command -v tmux &>/dev/null && [[ -z "$TMUX" ]]; then
#   tmux new-session -A -s main
# fi
