#!/bin/bash

# Set the default editor
export EDITOR="vim"

# `s` with no arguments opens the current directory in Sublime Text, otherwise opens the given location
function s() {
    if [ $# -eq 0 ]; then
        subl .
    else
        subl "$@"
    fi
}
