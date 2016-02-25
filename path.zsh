# Load Node global installed binaries
export PATH="$HOME/.node/bin:$PATH"

# Use project specific binaries before global ones
export PATH="node_modules/.bin:$PATH"

# Load Composer global installed binaries
export PATH="$HOME/.composer/vendor/bin:$PATH"

# Use project specific binaries before global ones
export PATH="vendor/bin:$PATH"

# Make sure PHP 7 is loaded
export PATH="$(brew --prefix homebrew/php/php70)/bin:$PATH"

# Make sure coreutils are loaded before system commands
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

# Bin directory
export PATH="$HOME/bin:$PATH"
