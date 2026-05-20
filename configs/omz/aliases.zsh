# Shortcut aliases and functions
alias badge='tput bel'
alias cls="clear"
alias shrug="echo '¯\_(ツ)_/¯'"
if [[ "$(uname -a)" =~ "Darwin" ]]; then
  alias beep="say -v Yuri \"My liege, the task is complete\""
  alias clipboard="pbcopy"
  alias copyssh="pbcopy < ${HOME}/.ssh/id_rsa.pub"
  alias fixzoom="sudo killall VDCAssistant"
  alias flushdns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
  alias library="cd ${HOME}/Library"
fi
if [[ -n "$(command -v zsh 2>/dev/null)" ]]; then
  alias reload="omz reload"
  alias reloadshell="omz reload"
fi
yn() {
  test $@ && echo yup || echo nope
}
avs () {
  profile=$1
  shift
  aws-vault exec $profile -- "$@"
}
pathsum() {
  pwd | cksum | cut -f1 -d ' '
}

# tmux
tmj() {
  session_group=main
  session_name=main
  if [[ "$#" -eq 2 ]]; then
    session_group=$1
    session_name=$2
  elif [[ "$#" -eq 1 ]]; then
    session_group=$1
  fi
  tmux new-session -AP \
    -F "Session #{session_name} joined in group #{session_group} with #{session_windows} window(s):\n  #{session_stack}" \
    -c "$(pwd)" \
    -s "${session_name}" \
    -t "${session_group}"
}
tmi() {
  session_name=main
  window_name=$(pathsum)
  if [[ "$#" -eq 2 ]]; then
    session_name=${1}
    window_name=${2}
  elif [[ "$#" -eq 1 ]]; then
    window_name=${1}
  fi
  tmux new-window -PS \
    -F 'Window #{window_name} attached to session #{session_name} in group #{session_group} @ index #{window_index})' \
    -c "$(pwd)" \
    -t "${session_name}" \
    -n "${window_name}"
}
alias tkeys='tmux list-keys | fzf'
alias tmup='tmi portal portal'

# Python aliases and functions
alias python="python3"
alias py="python3"
alias pip="pip3"

# Directory and file aliases and functions
dotfiles () { cd "${DOTFILES:?DOTFILES not set}" }
src () { cd "$HOME/src/$@" }
edots () {
  ${EDITOR:?EDITOR not defined} "${DOTFILES}"
}
ehosts () {
  ${EDITOR:?EDITOR not defined} /etc/hosts
}
edotaliases () {
  ${EDITOR:?EDITOR not defined} "${HOME}/.aliases"
}
egem () {
  ${EDITOR:?EDITOR not defined}
  if [[ -z "${1:-}" ]]; then
    echo "Usage: egem <gem_name>"
    return 1
  fi

  # echo "Attempting to open gem '$1' from bundler gems"
  bundle_stat=$(bundle show "$1" &>/dev/null; echo $?)
  # echo "Bundle show exit status: $bundle_stat"
  if [[ $bundle_stat -eq 0 ]]; then
    echo "Opening gem '$1' from bundler gems"
    bundle open "$1"
  else
    # echo "Could not find gem '$1' in bundler gems, trying system gems"
    gem_stat=$(gem which "$1" &>/dev/null; echo $?)
    # echo "Gem which exit status: $gem_stat"
    if [[ $gem_stat -eq 0 ]]; then
      echo "Opening gem '$1' from system gems"
      gem open "$1"
    else
      echo "Could not find gem '$1' in bundler or system gems"
      return 1
    fi
  fi
}

# Utility aliases and functions
epoch () {
  if [[ -n "${1:-}" ]]; then
    if [[ -n "$(command -v ruby 2>/dev/null)" ]]; then
      cmd="puts Time.at(${1})"
      $(command -v ruby) -e $cmd
    else
      echo Ruby command not found. Try using without a date argument.
      return 1
    fi
  else
    echo $(date +%s)
  fi
}
alias timestamp="epoch"
readme () {
  if [[ -z "$(command -v pandoc 2>/dev/null)" ]] || [[ -z "$(command -v lynx 2>/dev/null)" ]]; then
    return 1;
  fi
  if [[ -n "${1:-}" ]]; then
    pandoc $1 | lynx -stdin
  else
    pandoc README.md | lynx -stdin
  fi
}
rvmrc () {
  [[ -z "$(command -v rvm 2>/dev/null)" ]] && echo "rvm not installed" && return 1

  if [[ -z "${1:-}" ]]; then
    rvm --create --ruby-version use $(rvm current)
  else
    rvm --create --ruby-version use ${1}
  fi
}
# https://github.com/chubin/wttr.in
forecast () { curl -4 wttr.in/${1:-}\?uF }
weather () { curl -4 wttr.in/${1:-}\?uF${2:-n1} }

# Git aliases and functions
alias git-bdiff='git-branch-diff'     # Show commits in <source> that are not in <target>
alias git-bin='git-branch-incoming'   # Lists commits in the <source> that are not in the current working branch
alias git-bout='git-branch-outgoing'  # Lists commits in the current working branch that are not in the <target>
alias git-mb='git-make-branch'        # Create a new branch from the current branch with a name based on the supplied arguments
alias gpom='git pom'                  # Short for `git pull origin [default_branch]`, typically `main` or `master`
alias lg='lazygit'
git-make-branch () {
  if [[ "$#" -gt 0 ]]; then
    branch=$(ruby -e 'puts ARGV.join(" ").strip.gsub(/[\W\s_]+/, " ").downcase.split(" ").join("_")' "$@")
    echo "Attempting to create branch names '$branch'"
    if [[ -z "$branch" ]]; then
      echo "-- Could not create branch from supplied arguments"
      return 1
    else
      git switch -c $branch
    fi
  else
    echo "-- No arguments supplied"
    return 1
  fi
}
git-branch-diff () {
  if [[ "$#" -lt 2 ]] || [[ "${1:-}" = "--help" ]] || [[ "${1:-}" = "-h" ]]; then
    echo "Lists commits in the source commitish that are not in the target commitish, i.e. commits that would be added if you merged source into target"
    echo "Usage: git-branch-diff <source-commitish> <target-commitish>"
    echo "Alias: git-bdiff"
    return 0
  else
    log=$(git log --no-merges --format='%h | Author:%an | Date:%ad | %s' --date=local ${1}..${2} --)
    if [[ -z "$log" ]]; then
      echo "'${2}' has no commits that '${1}' does not also have"
    else
      echo "'${2}' has these commits and '${1}' does not:"
      echo "$log"
    fi
  fi
}
git-branch-incoming () {
  if [[ "$#" -lt 1 ]] || [[ "${1:-}" = "--help" ]] || [[ "${1:-}" = "-h" ]]; then
    echo "Lists commits in the source commitish that are not in the current working branch, i.e. incoming commits if you merged the source commitish into the working branch."
    echo "Usage: git-branch-incoming <source-commitish>"
    echo "Alias: git-bin"
    return 0
  fi
  git-branch-diff "$(git branch --show-current)" "${1}"
}
git-branch-outgoing () {
  if [[ "$#" -ne 1 ]]; then
    echo "Lists commits in the current working branch that are not in the target commitish, i.e. outgoing commits if you merged the working branch into the target."
    echo "Usage: git-branch-outgoing <target-commitish>"
    echo "Alias: git-bout"
    return 0
  fi
  git-branch-diff "${1}" "$(git branch --show-current)"
}
function git_recent() # Courtesy of Jay McGavren at Huntress
{
  git switch $(git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short)' --color | head -n 8 | fzf --height 20%)
}

# Worktrunk (wt) aliases and functions
wt-merged () {
  wt list --format=json | jq -r '.[] | select(.main_state == "integrated" or .main_state == "empty") | .branch'
}
wt-clean () {
  wt-merged | xargs wt remove --force
}
