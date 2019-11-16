# Shortcuts
alias copyssh="pbcopy < $HOME/.ssh/id_ed25519.pub"
alias reloadcli="source $HOME/.zshrc"
alias reloaddns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias phpstorm='open -a /Applications/PhpStorm.app "`pwd`"'

# Directories
alias dotfiles="cd $DOTFILES"
alias sites="cd $HOME/Sites"

# Laravel
alias art="php artisan"
alias ams="php artisan migrate:fresh --seed"

# PHP
alias cfresh="rm -rf vendor/ composer.lock && composer i"

# JS
alias nfresh="rm -rf node_modules/ package-lock.json && npm install"
alias watch="npm run watch"

# Git
alias commit="git add . && git commit -m"
alias gcommit="git add . && git commit"
alias amend="git commit --amend --no-edit"
alias amendall="git add . && amend"
alias wip="commit wip"
alias gst="git status"
alias gb="git branch"
alias gc="git checkout"
alias gd="git diff"
alias resolve="git add . && git commit --no-edit"
alias gl="git log --oneline --decorate --color"
alias nuke="git clean -df && git reset --hard"
