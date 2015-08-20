#!/bin/zsh

clear

disabled() {
    print -P "\n%F{1}disabled%f."
    exit 0
}

abort() {
    print -P "\n✗ %F{3}aborting%f ✗\n"
    exit 1
}

section () {
    print -P "\n[ %F{4}$1%f ] $2"
}

ok() {
    print -P "[ %F{2}✔%f ] $1\n"
}

formatexec() {
    local _exec="$1"

    print -P "%F{8}> $_exec%f"
    # eval "$_exec"
}

finished() {
    print -P "\nDONE."
    print -P "\n%F{8}✎ with %F{1}♥%F{8} by %F{12}stoe%F{8} (https://github.com/stoe/.dotfiles)%f"
    source "$HOME/.zshrc"
}
