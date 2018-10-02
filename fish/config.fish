# config.fish

set -g theme_color_scheme plus
set -g theme_nerd_fonts yes
set -g theme_newline_cursor no
set -g theme_display_git yes
set -g theme_display_git_dirty yes
set -g theme_display_git_untracked yes
set -g theme_display_git_ahead_verbose yes
set -g theme_display_git_dirty_verbose yes
set -g theme_display_git_master_branch yes
set -g theme_git_worktree_support no
set -g theme_display_vagrant yes
set -g theme_display_docker_machine yes
set -g theme_display_k8s_context yes
set -g theme_display_hg yes
set -g theme_display_virtualenv yes
set -g theme_display_ruby yes
set -g theme_display_user yes
set -g theme_display_hostname ssh
set -g theme_display_vi no
set -g theme_avoid_ambiguous_glyphs yes
set -g theme_powerline_fonts no
set -g theme_nerd_fonts yes
set -g theme_show_exit_status yes
set -g fish_prompt_pwd_dir_length 0
set -g theme_project_dir_length 1
set -g color_fish ffffff 181818 --bold

# Load private stuff - keys and such
source $HOME/.private_profile

abbr -a l ls
abbr -a ll ls -lAh
abbr -a la ls -a
abbr -a ls command ls -la

# git
abbr -a ga git add .
abbr -a gc git commit -m
abbr -a gco git checkout
abbr -a gs git status -sb
abbr -a gp git push
abbr -a got git
abbr -a gut git
abbr -a glog git log --oneline --decorate
abbr -a lsg 'git tag -l [0-9]*'
abbr -a commits git shortlog -s -n

function gl
  git pull origin (git rev-parse --abbrev-ref HEAD)
end

# git clone and cd into directory
function clone
  git clone $1 \
  and cd `echo $1 | sed -n -e 's/^.*\/\([^.]*\)\(.git\)*/\1/p'` \
  and git branch --set-upstream-to=origin/master master
end

# Rails shortcuts
abbr -a begs bundle exec guard start
abbr -a beef bundle exec foreman start
abbr -a be bundle exec
abbr -a rs bundle exec rails s
abbr -a rc bundle exec rails c
abbr -a rollback time bundle exec rake db:rollback --trace
abbr -a migrate time bundle exec rake db:migrate -- trace
abbr -a reset time bundle exec rake db:reset --trace
abbr -a seed time bundle exec rake db:seed --trace
abbr -a populate time bundle exec rake db:populate --trace

#tmux
abbr -a tmux 'TERM=screen-256color-bce tmux'
abbr -a tnew tmux new -s
abbr -a tlist tmux ls
abbr -a tat tmux attach -t

abbr -a grep "GREP_COLOR='31' grep -in --color=auto 2>/dev/null"
abbr -a bup 'source ~/.bash_profile'
abbr -a ttop 'top -U $USER'
abbr -a bedit 'subl ~/.bash_profile'
