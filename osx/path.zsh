# Make sure coreutils are loaded before system commands
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"