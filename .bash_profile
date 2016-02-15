# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Load the shell dotfiles
# * .aliases can be used to load command aliases
# * .path can be used to extend `$PATH`.
# * .private can be used for other settings you don’t want to commit
# First start with iterating over each directory we want to check for these files
for directory in {~,~/.dotfiles,~/.dotfiles/osx,~/.dotfiles/node,~/.dotfiles/php,~/.dotfiles/vagrant}; do
  # Now check if we can find these files
  for file in "$directory"/.{aliases,path,private}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
  done;
  unset file;
done;
unset directory;

# Language Preferences
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
