#!/bin/zsh

function brewup() {
  # see https://gist.github.com/fvdm/1715d580a22503ce115c#file-homebrew_update-sh
  # thanks https://github.com/fvdm

  local _brew=$(which brew)

  # if [ "$1" = "-h" ]; then
  #   section "Colorful Homebrew update script"
  #   echo
  #   echo "USAGE: brewup [-y]"
  #   echo
  #   echo "   -y  skip questions"
  #   echo "   -h  display this help"
  #   echo
  #   exit 0
  # fi

  echo $_brew

  section "Fetching packages list"
  formatexec "$_brew update"
  local _brewsy=$($_brew outdated | wc -l | awk '{print $1}')

  if [ "$_brewsy" != 0 ]; then
    print -P "%F{3}Outdated packages:%f" "$_brewsy"
    echo
    formatexec "$_brew outdated"

    if [ "$1" != "-y" ]; then
      question "Update the these packages?" "yn"
      read -rs -k 1 ask
      print -P "%F{8}> $ask%f"
    fi

    if [ "$ask" = "y" ]; then
      formatexec "$_brew upgrade --all"
    else
      ok "OK, not doing anything"
    fi
  else
    ok "Nothing to do"
  fi

  section "Doctor & Cleanup"
  formatexec "$_brew doctor"
  formatexec "$_brew cleanup"

  echo
  ok "DONE"

}
