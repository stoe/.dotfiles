#!/bin/zsh
source "$HOME/.dotfiles/inc/helpers.sh"

section "atom packages"
PACKAGES=(
  atom-markdown-wrapper
  atom-snazzy-clear-syntax
  atomic-chrome
  autocomplete-emojis
  ava
  busy-signal
  carbon-now-sh
  dash
  date
  editorconfig
  focus-dark
  focus-light
  import-sf-mono
  intentions
  language-babel
  language-csv
  language-docker
  language-dotenv
  language-graphql
  language-terra
  language-terraform
  linter
  linter-terraform-semantics
  linter-terraform-syntax
  linter-ui-default
  linter-xo
  markdown-table-formatter
  markdown-toc
  pdf-view
  prettier-atom
  print-atom
  project-manager
  tabs-to-spaces
  teletype
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
