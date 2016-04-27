#!/bin/zsh
source "$HOME/.dotfiles/inc/helpers.sh"

# The Brewfile handles Homebrew-based app and library installs, but there may
# still be updates and installables in the Mac App Store. There's a nifty
# command line interface to it that we can use to just install everything, so
# yeah, let's do that.

section "Update Mac App Store apps"
formatexec "sudo softwareupdate -i -a"
