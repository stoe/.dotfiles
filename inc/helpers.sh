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

  print -P "%F{4}$question%f"
  print -P "%F{2}[$options]%f"
}

section () {
  print -P "\n[ %F{4}$1%f ] $2"
}
