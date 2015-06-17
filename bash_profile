# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{aliases,private}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Ruby Version Manager
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# $PATH
export PATH=vendor/bin:node_modules/.bin:$HOME/.bin:$HOME/.node/bin:$HOME/.composer/vendor/bin:$PATH

# Autocomplete Git commands and branches
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Language Preferences
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
