# Add directories to the PATH and prevent to add the same directory multiple times upon shell reload.
add_to_path() {
  if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]] && [[ ":$PATH:" != "$1:"* ]]; then
    export PATH="$1:$PATH"
  fi
}

# Load Herd injected PHP binaries
add_to_path "/Users/driesvints/Library/Application Support/Herd/bin"

# Load dotfiles binaries
add_to_path "$DOTFILES/bin"

# Load global Composer tools
add_to_path "$HOME/.composer/vendor/bin"

# Load global Node installed binaries
add_to_path "$HOME/.node/bin"

# Use project specific binaries before global ones
add_to_path "vendor/bin"
add_to_path "node_modules/.bin"

# Add Herd services
add_to_path "/Users/Shared/Herd/services/mysql/8.0.36/bin"
add_to_path "/Users/Shared/Herd/services/redis/7.0.0/bin"
