#!/bin/zsh
source "$HOME/.dotfiles/inc/helpers.sh"

section "atom packages"
PACKAGES=(
  atom-markdown-wrapper
  atom-material-syntax
  atom-material-syntax-light
  atom-material-ui
  atomic-chrome
  autocomplete-emojis
  date
  editorconfig
  gist-it
  git-plus
  language-apache
  language-ini
  language-nginx
  markdown-table-formatter
  merge-conflicts
  minimap
  minimap-git-diff
  project-manager
)

for PACKAGE in $PACKAGES; do
  if $(apm ls | grep "$PACKAGE@[0-9\.]*$" > /dev/null 2>&1); then
      formatexec "apm upgrade $PACKAGE"
      print -P "  └ %F{3}upgraded%f"
  else
      formatexec "apm install $PACKAGE > /dev/null 2>&1"
      print -P "  └ %F{2}installed%f"
  fi
done
