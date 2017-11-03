#!/bin/zsh

abort() {
  print -P "\n✘ %F{3}aborting%f ✘\n"
  exit 1
}

disabled() {
  print -P "\n%F{1}disabled%f."
  exit 0
}

finished() {
  print -P "\nDONE."
  print -P "\n%F{8}✎ with %F{1}♥%F{8} by %F{12}stoe%F{8} (https://github.com/stoe/.dotfiles)%f"

  source "$HOME/.zshrc"
}

formatexec() {
  local _exec="$1"

  print -P "%F{8}> $_exec%f"
  eval "$_exec"
}

ok() {
  print -P "\n[ %F{2}✓%f ] $1\n"
}

question() {
  local question="$1"
  local options="$2"

  print -P "%F{3}$question%f"
  [ "$options" != "" ] && print -P "%F{2}[$options]%f"
}

section () {
  print -P "\n[ %F{4}$1%f ] $2"
}

### Functions for setting and getting environment variables from the OSX keychain ###
### Adapted from https://www.netmeister.org/blog/keychain-passwords.html ###

### from https://gist.github.com/bmhatfield/f613c10e360b4f27033761bbee4404fd ###

# Use: keychain-environment-variable SECRET_ENV_VAR
function keychain-environment-variable () {
  security find-generic-password -w -a ${USER} -D "environment variable" -s "${1}"
}

# Use: set-keychain-environment-variable SECRET_ENV_VAR
#   provide: super_secret_key_abc123
function set-keychain-environment-variable () {
  [ -n "$1" ] || print "Missing environment variable name"

  # Note: if using bash, use `-p` to indicate a prompt string, rather than the leading `?`
  read -s "?Enter Value for ${1}: " secret

  ( [ -n "$1" ] && [ -n "$secret" ] ) || return 1
  security add-generic-password -U -a ${USER} -D "environment variable" -s "${1}" -w "${secret}"
}
