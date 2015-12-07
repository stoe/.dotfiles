#!/bin/zsh

clear

disabled() {
    print -P "\n%F{1}disabled%f."
    exit 0
}

abort() {
    print -P "\n\u${CODEPOINT_OF_ANONYMICE_UNIF468} %F{3}aborting%f \u${CODEPOINT_OF_ANONYMICE_UNIF468}\n"
    exit 1
}

section () {
    print -P "\n[ %F{4}$1%f ] $2"
}

ok() {
    print -P "[ %F{2}\u${CODEPOINT_OF_ANONYMICE_UNIF42E}%f ] $1\n"
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
