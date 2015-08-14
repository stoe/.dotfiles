#!/bin/zsh

# NPM cleaned up "ls" (no dependencies)
function npmls() {
    npm ls "$@" | grep "^[└├]" | sed "s/─┬/──/g"
}
