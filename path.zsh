#Keep all exports here 

# Load dotfiles binaries
export PATH="$DOTFILES/bin:$PATH"

# Make sure coreutils are loaded before system commands
# I've disabled this for now because I only use "ls" which is
# referenced in my aliases.zsh file directly.
#export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

#for JDK 1.8
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_333.jdk/Contents/Home"

# get Maven setup
# add Apache Maven to the path
# if you are using maven 3.x, use these *instead of* the variables below
# Note: maven 3.5.4 is recommended as latest=3.6.0 currently(Jan-2019) has 'findbugs' discrepancies observed
export M3_HOME="/usr/local/Cellar/maven/3.8.6" # replace n.n.n with appropriate version
export M3="$M3_HOME/bin"
export PATH="$M3:$PATH"
 