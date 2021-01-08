#!/bin/zsh

export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

setopt HIST_IGNORE_ALL_DUPS    # Delete old recorded entry if new entry is a duplicate.
setopt HIST_IGNORE_SPACE       # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS       # Don't write duplicate entries in the history file.

autoload -Uz colors && colors

# initialize autocomplete here, otherwise functions won't be loaded
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

if type gh &>/dev/null; then
  eval "$(gh completion -s zsh)"
fi

autoload -Uz compinit
compinit

if [[ $OSTYPE =~ "darwin" ]]; then
  source $HOME/.zshrc.macos
fi

source <(npx --shell-auto-fallback zsh)
