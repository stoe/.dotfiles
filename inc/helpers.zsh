#!/bin/zsh

abort() {
  print -P "✘ ${yellow}aborting${reset_color} $1\n"
  return
}

disabled() {
  print -P "${red}disabled${reset_color}.\n"
  return 1
}

finished() {
  print -P "\n${grey}✎ with ${red}♥${grey} by %F{12}stoe${grey} (https://github.com/stoe/.dotfiles)${reset_color}"

  source "$HOME/.zshrc"
}

formatexec() {
  local _exec="$1"

  print -P "${grey}> $_exec${reset_color}"
  eval "$_exec"
}

ok() {
  print -P "[ ${green}✓${reset_color} ] $1"
}

question() {
  local question="$1"
  local options="$2"

  print -P "${cyan}${question}${reset_color}"
  [ "$options" != "" ] && print -P "${green}[$options]${reset_color}"
}

section () {
  print -P "\n[ ${magenta}$1${reset_color} ] $2"
}
