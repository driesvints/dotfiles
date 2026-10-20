if [[ "$ZSH_DEBUG" == "ON" ]]; then echo "[DEBUG] setting up aliases from .dotfiles/aliases.zsh"; fi

# re-init .zshrc
alias reloadzshrc="cp $HOME/.dotfiles/.zshrc $HOME/.zshrc"

# Shortcuts
alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"
alias reloadcli="source $HOME/.zshrc"
alias reloaddns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
#alias ll="$(brew --prefix coreutils)/libexec/gnubin/ls -ahlF --color --group-directories-first"
alias ll="ls -lha"
alias weather="curl -4 http://wttr.in"
alias shrug="echo '¯\_(ツ)_/¯' | pbcopy"

# Directories
alias dotfiles="cd $DOTFILES"
alias library="cd $HOME/Library"
alias sites="cd $HOME/Sites"

# Vagrant
alias v="vagrant global-status"
alias vup="vagrant up"
alias vhalt="vagrant halt"
alias vssh="vagrant ssh"
alias vreload="vagrant reload"
alias vrebuild="vagrant destroy --force && vagrant up"

# Kubernetes
alias k_context_dev-fss="kubectl config use-context dev-fss"
alias k_context_dev-sbs="kubectl config use-context dev-sbs"
alias k_context_prod-fss="kubectl config use-context prod-fss"
alias k_context_prod-sbs="kubectl config use-context prod-sbs"
alias k_pods_teamtag="kubectl get pods -l team=teamtag"
alias k_logs_pod="kubectl log -f"
alias k_apply_dev="kubectl apply -f dev-nais.yaml"

# Utils
alias listen_p="lsof -i -P -n | grep LISTEN"

# KI i nav
alias copilot='cplt --'
alias np='nav-pilot'

echo "aliases set up"
