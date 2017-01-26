#!/bin/zsh
source "$HOME/.dotfiles/inc/helpers.sh"

section "atom packages"
PACKAGES=(
  atom/github
  atom-markdown-wrapper
  atom-material-syntax
  atom-material-syntax-light
  atom-material-ui
  atom-snazzy-clear-syntax
  atomic-chrome
  autocomplete-emojis
  date
  editorconfig
  es6-javascript
  gist-it
  git-log
  git-plus
  import-sf-mono
  language-apache
  language-babel
  language-ini
  language-nginx
  markdown-table-formatter
  markdown-toc
  merge-conflicts
  minimap
  minimap-git-diff
  prettier-atom
  project-manager
  turbo-javascript
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
