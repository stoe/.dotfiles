#!/bin/zsh

source "../inc/helpers.zsh"

print -P "installing %F{11}atom.io packages%f\n"

if [ ! $(which apm) ]; then
    print -P "%F{4}atom%f and/or %F{4}apm%f are not installed."

    abort
fi

packages=(
    atom-material-syntax atom-material-ui
    gist-it
    language-apache language-ini language-nginx
    linter
    linter-csslint linter-scss-lint linter-less
    linter-eslint linter-jshint linter-coffeelint linter-jsonlint
    linter-php
    linter-shellcheck
    merge-conflicts
    minimap minimap-git-diff minimap-linter
    pigments
    project-manager
)

for package in $packages; do
    install="apm install $package"
    update="apm update $package"

    if [ $(apm view $package | grep "Not Found") ]; then
        formatexec $install
    else
        formatexec $update
    fi
done

formatexec "apm dedupe"
formatexec "apm clean"

# DONE & RELOAD ----------------------------------------------------------------
finished
