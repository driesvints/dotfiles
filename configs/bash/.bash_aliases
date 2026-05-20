#!/bin/sh

# GENERAL COMMANDS
alias beep="say -v Fred \"My liege, the task is complete\""
alias diff=colordiff
alias flushdns='sudo discoveryutil udnsflushcaches'
alias hist="history | grep -i"
alias reload='source ~/.bash_profile'
# alias t='/usr/local/bin/todo.sh -d /Users/chrisbloom/todo.cfg'
# alias c='clear'
# alias cx='chmod +x'
# alias mail_log="tail -f /private/var/log/mail.log"
# alias release='xattr -d com.apple.quarantine'
# alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

# TMUX COMMANDS
alias tkeys='tmux list-keys | fzf'
alias tmup='tmux attach -t portal'

# RUBY / RUBY ON RAILS COMMANDS
alias bexec='bundle exec'
alias rails_mv="bexec rails -v | sed 's/Rails \([0-9]\).*/\1/g'"
# Alias the rake command to Spring binstubs or fallback to "bundle exec"
# http://goo.gl/HkhHAf, http://goo.gl/STtIvF
function brake {
  if [ -f bin/rake ]
  then
    bin/rake "$@"
  else
    if [ `rails_mv` -lt 3 ]; then
      rake "$@"
    else
      bexec rake "$@"
    fi
  fi
}
function brails {
  if [ -f bin/rails ]
  then
    bin/rails "$@"
  else
    bexec rails "$@"
  fi
}
function bspec {
  if [ -f bin/rspec ]
  then
    bin/rspec "$@"
  else
    bexec rspec "$@"
  fi
}
function cons {
  if [ `rails_mv` -lt 3 ]; then
    ./script/console "$@"
  else
    brails c "$@"
  fi
}
function dbcons {
  if [ `rails_mv` -lt 3 ]; then
    echo "Not supported in this version of Rails (`rails -v`)"
  else
    brails db "$@"
  fi
}
function gen {
  if [ `rails_mv` -lt 3 ]; then
    ./script/generate "$@"
  else
    brails g "$@"
  fi
}
function srv {
  if [ `rails_mv` -lt 3 ]; then
    ./script/server "$@"
  else
    brails s "$@"
  fi
}
function run {
  if [ `rails_mv` -lt 3 ]; then
    ./script/runner "$@"
  else
    brails r "$@"
  fi
}
alias sandbox='cons --sandbox'
alias epoch="ruby -e 'puts Time.now.to_i'"
alias timestamp='epoch'
alias truncate_logs='find ./log -size +1c -type f -name "*.log" | while IFS= read -r fname ; do > "$fname" ; done'

# TEXTMATE SHORTUTS
alias mate_aliases='mate ~/.bash_aliases'
alias mate_bashrc='mate ~/.bashrc'
alias mate_bash_login='mate ~/.bash_login'
alias mate_bash_profile='mate ~/.bash_profile'
alias mate_hosts='mate /etc/hosts'

# GIT COMMANDS
function git-make-branch {
  echo "\$@ = '$@'"
  typeset branch
  if [[ "$@" != "" ]]; then
    branch=$(ruby -e 'puts ARGV.join(" ").strip.gsub(/[\W\s_]+/, " ").downcase.split(" ").join("_")' "$@")
    # echo "branch = '$branch'"
    if [[ "$branch" = "" ]]; then
      echo "-- Could not create branch from supplied arguments"
    else
      git co -b "$branch"
      echo "-- Created branch $branch"
    fi
  else
    echo "-- Could not create branch from supplied arguments"
  fi
}
alias git-mb='git-make-branch'

# From http://stackoverflow.com/a/2831173/83743
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function git-branch-incoming {
    echo branch \($1\) has these commits and \($(parse_git_branch)\) does not
    git log ..$1 --format='%h | Author:%an | Date:%ad | %s' --date=local --no-merges
}
alias git-bin='git-branch-incoming'

function git-branch-outgoing {
    echo branch \($(parse_git_branch)\) has these commits and \($1\) does not
    git log $1.. --format='%h | Author:%an | Date:%ad | %s' --date=local --no-merges
}
alias git-bout='git-branch-outgoing'
