#!/bin/zsh
source "$HOME/.dotfiles/inc/helpers.sh"

# install dependencies
GEMS=(
  bundler
  octokit
  pry
)

for GEM in $GEMS; do
  if $(gem list --no-version | grep "$GEM" > /dev/null 2>&1); then
    formatexec "gem update $GEM"
    print -P "  └ %F{3}upgraded%f"
  else
    formatexec "gem install $GEM > /dev/null 2>&1"
    print -P "  └ %F{2}installed%f"
  fi
  echo
done
