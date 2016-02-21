# CLI Shortcuts
alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"
alias reloadcli="source $HOME/.zshrc"
alias reloaddns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias ll="ls -ahlF --color --group-directories-first"
alias weather="curl -4 http://wttr.in"

# Directories
alias dotfiles="cd $DOTFILES"
alias sites="cd $HOME/Sites"
