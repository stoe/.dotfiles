#!/bin/zsh

abort() {
  print -P "✘ %178Faborting%f $1\n"
  return
}

disabled() {
  print -P "%1Fdisabled%f\n"
  return 0
}

finished() {
  print -P "\n%244F✎ with %1F♥%244F by %39Fstoe%244F (https://github.com/stoe/.dotfiles)%f"

  source "$HOME/.zshrc"
}

formatexec() {
  local _exec="$1"

  print -P "%244F> $_exec%f"
  eval "$_exec"
}

ok() {
  print -P "[ %76F✓%f ] $1"
}

question() {
  local question="$1"
  local options="$2"

  print -P "%39F${question}%f"
  [ "$options" != "" ] && print -P "%244F[$options]%f"
}

section () {
  print -P "\n[ %5F$1%f ] $2"
}
