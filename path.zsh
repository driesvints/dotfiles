# Load dotfiles binaries
export PATH="$DOTFILES/bin:$PATH"

# Load Node global installed binaries
export PATH="$HOME/.node/bin:$PATH"

# Use project specific binaries before global ones
export PATH="node_modules/.bin:vendor/bin:$PATH"

# Make sure coreutils are loaded before system commands
# I've disabled this for now because I only use "ls" which is
# referenced in my aliases.zsh file directly.
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

# Use gnu-sed instead of gsed
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

# Use gnu-find instead of gfind
export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"

# use homebrew curl
export PATH="/usr/local/opt/curl/bin:$PATH"

# mysql client
export PATH="/usr/local/opt/mysql-client/bin:$PATH"

# Visual Studio Code
export PATH="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/:$PATH"

# Local binaries
export PATH="$HOME/.local/bin:$PATH"

# User binaries
export PATH="$HOME/bin:$PATH"
