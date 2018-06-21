#!/bin/bash

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWSTASHSTATE=true
export PROMPT_DIRTRIM=3

if [[ ${EUID} == 0 ]] ; then
    PS1='\[\033[0;33m\][\[\033[0;31m\]\u\[\033[0;31m\]@\[\033[0;31m\]\h \[\033[1;32m\]\w\[\033[0;33m\]]\[\033[0;31m\]$(declare -F __git_ps1 &>/dev/null && __git_ps1 "(%s)")\[\033[0;37m\]\\$ \[\033[00m\]'
else
    PS1='\[\033[0;33m\][\[\033[0;36m\]\u\[\033[0;36m\]@\[\033[0;36m\]\h \[\033[0;32m\]\w\[\033[0;33m\]]\[\033[0;31m\]$(declare -F __git_ps1 &>/dev/null && __git_ps1 "(%s)")\[\033[0;37m\]\\$ \[\033[00m\]'
fi
