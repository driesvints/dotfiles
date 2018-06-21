#!/bin/bash

if [ -x /usr/bin/dircolors ]; then
    test -r /etc/lscolors && eval "$(dircolors -b /etc/lscolors)" || eval "$(dircolors -b)"
elif [ -x /usr/local/bin/gdircolors ]; then
    test -r /etc/lscolors && eval "$(gdircolors -b /etc/lscolors)" || eval "$(gdircolors -b)"
fi

BASE16_SHELL="/etc/base16-eighties.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

export CLICOLOR=1

if [ -x /usr/local/bin/gls ]; then
    alias ls='gls --color=auto'
elif ls --color > /dev/null 2>&1; then
    alias ls='ls --color=auto'
else
    alias ls='ls -G'
fi

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

export GREP_OPTIONS='--color=auto';
