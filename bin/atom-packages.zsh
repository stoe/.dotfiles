#!/bin/zsh

source "../inc/helpers.zsh"

# DISABLED ---------------------------------------------------------------------
disabled

print -P "installing %F{11}atom.io packages%f\n"

if [ ! $(which apm) ]; then
    print -P "%F{4}atom%f and/or %F{4}apm%f are not installed."

    abort
fi

pkgs=(
    atom-material-ui atom-material-syntax atom-material-syntax-light
    editorconfig
    file-type-icons
    gist-it
    language-apache language-ini language-nginx
    linter
    linter-csslint linter-scss-lint linter-less
    linter-eslint linter-jshint
    linter-jsonlint linter-coffeelint
    linter-php
    linter-ruby
    linter-shellcheck
    merge-conflicts
    minimap
    minimap-autohide minimap-git-diff minimap-linter
    pigments
    project-manager
)

for pkg in $pkgs; do
    install="apm install $pkg"
    update="apm update $pkg"

    if [ $(apm view $pkg | grep "Not Found") ]; then
        formatexec $install
    else
        formatexec $update
    fi
done

echo ""
formatexec "apm dedupe"
formatexec "apm clean"

# DONE & RELOAD ----------------------------------------------------------------
finished
