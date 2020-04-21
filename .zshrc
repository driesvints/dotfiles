HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=20000

DOTFILES=$HOME/.dotfiles

# Allow extended glob patterns (like '**/' is actually '(*/)#')
setopt extended_glob

# Allow comments to be put in the command-line
#
#   $ echo 'Hello World'    # This comment will be valid now
#
# http://stackoverflow.com/questions/11670935/comments-in-command-line-zsh
setopt interactivecomments

# Add to path conditionally
#
# The idea is that I noticed my $PATH to contain clutter, and something output
# from "env" like programs makes me scrollblind as it shows irrelevant output.
#
# An by-arash-improved version of http://superuser.com/a/39995/97600
addpath () {
    if [[ -d "$1" ]] &&  [[ ":$PATH:" != *":$1:"* ]]
    then
        export PATH="$1:$PATH"
    fi
}

# Initialize colors
# Necessary for
#     $ echo "$fg[blue] hello world"
# Like is uesd in zsh-colors
autoload -U colors
colors

# Initialize antigen-hs
if [[ -f ~/.zsh/antigen-hs/init.zsh ]]
then
  export ANTIGEN_HS_MY=$DOTFILES/zsh/MyAntigen.hs
  . ~/.zsh/antigen-hs/init.zsh
fi


# Add to completions
fpath=(~/.zsh/plugins/completions/src $fpath)



# Enable completions
autoload -Uz compinit && compinit

HIST_STAMPS="dd/mm/yyyy"
