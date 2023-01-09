# Shortcuts
alias copyssh="pbcopy < $HOME/.ssh/id_ed25519.pub"
alias reloadshell="source $HOME/.zshrc"
alias reloaddns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias ll="/opt/homebrew/opt/coreutils/libexec/gnubin/ls -AhlFo --color --group-directories-first"
alias phpstorm='open -a /Applications/PhpStorm.app "`pwd`"'
alias shrug="echo '¯\_(ツ)_/¯' | pbcopy"
alias c="clear"
alias compile="commit 'compile'"
alias version="commit 'version'"

# Directories
alias dotfiles="cd $DOTFILES"
alias library="cd $HOME/Library"
alias sites="cd $HOME/Sites"
alias lara="sites && cd laravel/"
alias docs="lara && cd docs/"

# Docker
alias docker-composer="docker-compose"

# SQL Server
alias mssql="docker run -e ACCEPT_EULA=Y -e SA_PASSWORD=LaravelWow1986! -p 1433:1433 mcr.microsoft.com/mssql/server:2017-latest"

# Git
alias gst="git status"
alias gb="git branch"
alias gc="git checkout"
alias gl="git log --oneline --decorate --color"
alias amend="git add . && git commit --amend --no-edit"
alias commit="git add . && git commit -m"
alias diff="git diff"
alias force="git push --force"
alias nuke="git clean -df && git reset --hard"
alias pop="git stash pop"
alias pull="git pull"
alias push="git push"
alias resolve="git add . && git commit --no-edit"
alias stash="git stash -u"
alias unstage="git restore --staged ."
alias wip="commit wip"

# Mine
alias gspp='git stash && git pull -r && git stash pop'
alias yk='pkill -9 ssh-agent;pkill -9 ssh-pkcs11-helper;ssh-add -k -s /usr/local/lib/opensc-pkcs11.so; ssh-add -l'

#Functions 
# Refer to this for setup : https://confluence.oci.oraclecorp.com/pages/viewpage.action?spaceKey=OCAS&title=OCAS+Guide%3A+OB4+Overlay+Bastion+Access

 reload-ssh() {
    ssh-add -e /usr/local/lib/opensc-pkcs11.so >> /dev/null
    if [ $? -gt 0 ]; then
        echo "Failed to remove previous card"
    fi
    ssh-add -s /usr/local/lib/opensc-pkcs11.so
 }

#Oracle SSH helpers

function build_bastion_arg() {
    BASTION_ENDPOINT=`jq -r .$2 ~/.ssh/bastion_endpoints.json`
    BASTION_HOST=`jq -r .$1.$2.host ~/.ssh/bastion_host_configs.json`
    JUMP_HOST=`jq -r .$1.$2.jump ~/.ssh/bastion_host_configs.json`
    echo "$BASTION_ENDPOINT,$BASTION_HOST-$JUMP_HOST"
}
 
# sshs to the host in the format
# ssh -J [BASTION_ENDPOINT],[BASTION_HOST]-[JUMP_HOST] IP_ADDRESS]
# example: ssh_me adint phx 0.0.0.0
function ssh_me() {
    BASTION_ARGS="$(build_bastion_arg $1 $2)"
    #cat ~/.ssh/YUBIKEY_NAME.key
    eval 'ssh -J $BASTION_ARGS $3'
}
 
# sftps to the host in the format
# sftp -J [BASTION_ENDPOINT],[BASTION_HOST]-[JUMP_HOST] IP_ADDRESS]
# example: sftp_me adint phx 0.0.0.0
function sftp_me() {
    set -x
    BASTION_ARGS="$(build_bastion_arg $1 $2)"
    cat ~/.ssh/YUBIKEY_NAME.key
    eval 'sftp -J $BASTION_ARGS $3'
    set +x
}

#Sourcing 
#Not sure if i like autocomplete , will use autosuggestions for now
#source ~/Workspace/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source ~/Workspace/zsh-autosuggestions/zsh-autosuggestions.zsh