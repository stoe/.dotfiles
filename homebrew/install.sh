#!/bin/zsh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

source "$HOME/.dotfiles/inc/helpers.sh"

# Check for Homebrew
if test ! $(which brew); then
  section "Installing Homebrew for you."

  # Install the correct homebrew for each OS type
  if test "$(uname)" = "Darwin"; then
    formatexec "ruby -e $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  elif test "$(expr substr $(uname -s) 1 5)" = "Linux"; then
    formatexec "ruby -e $(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
  fi

fi

exit 0
