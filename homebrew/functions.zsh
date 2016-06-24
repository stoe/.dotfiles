# see https://gist.github.com/fvdm/1715d580a22503ce115c#file-homebrew_update-sh
# thanks https://github.com/fvdm
function brewup() {
  local _brew=$(which brew)

  section "Fetching packages list"
  formatexec "$_brew update"

  local _brewsy=`$_brew outdated | wc -l | awk '{print $1}'`

  if [ "$_brewsy" != 0 ]; then
    print -P "%F{3}Outdated packages:%f" "$_brewsy"
    echo
    formatexec "$_brew outdated"

    if [ "$1" != "-y" ]; then
      question "Update these packages?" "yn"
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
  echo
  formatexec "$_brew cask cleanup && $_brew cleanup"

  echo
  ok "DONE"
}
