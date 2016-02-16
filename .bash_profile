# We need the dotfiles location before we continue
export DOTFILES="$HOME/.dotfiles"

# Load the shell dotfiles
# * .config can be used to set some defaults like variables
# * .aliases can be used to load command aliases
# * .path can be used to extend $PATH
# * .private can be used for other settings you don’t want to commit
# First start with iterating over each directory we want to check for these files
for directory in {$HOME,$DOTFILES,$DOTFILES/osx,$DOTFILES/node,$DOTFILES/php,$DOTFILES/vagrant}; do
  # Now check if we can find these files
  for file in "$directory"/.{config,aliases,path,private}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
  done;
  unset file;
done;
unset directory;

# Language Preferences
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
