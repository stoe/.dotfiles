#!/bin/zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

setopt HIST_IGNORE_ALL_DUPS    # Delete old recorded entry if new entry is a duplicate.
setopt HIST_IGNORE_SPACE       # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS       # Don't write duplicate entries in the history file.

autoload -Uz colors && colors

# initialize autocomplete here, otherwise functions won't be loaded
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi

if type gh &>/dev/null; then
  eval "$(gh completion -s zsh)"
fi

# shortcut to this dotfiles path is $DFH
export DFH=$HOME/code/private/.dotfiles
[ -f "${DFH}/inc/paths.zsh" ] && source "${DFH}/inc/paths.zsh"
[ -f "${DFH}/inc/helpers.zsh" ] && source "${DFH}/inc/helpers.zsh"
[ -f "${DFH}/inc/functions.zsh" ] && source "${DFH}/inc/functions.zsh"
[ -f "${DFH}/inc/aliases.zsh" ] && source "${DFH}/inc/aliases.zsh"

# load local zshrc if present
[ -f "${HOME}/.zshrc.local" ] && source "${HOME}/.zshrc.local"

# load zgen
source "${HOME}/.zgen/zgen.zsh"

# if the init script doesn't exist
if ! zgen saved; then
  echo "Creating a zgen save"

  zgen oh-my-zsh

  # plugins
  zgen oh-my-zsh plugins/brew
  zgen oh-my-zsh plugins/docker
  zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/git-extras
  zgen oh-my-zsh plugins/git-lfs
  zgen oh-my-zsh plugins/gitignore
  zgen oh-my-zsh plugins/golang
  zgen oh-my-zsh plugins/node
  zgen oh-my-zsh plugins/nvm
  zgen oh-my-zsh plugins/macos
  zgen oh-my-zsh plugins/terraform
  zgen load zsh-users/zsh-syntax-highlighting

  # completions

  # theme
  zgen load romkatv/powerlevel10k powerlevel10k

  # generate the init script from plugins above
  zgen save
fi

export EDITOR="code --wait"
export GIT_EDITOR="code --wait"

export GPG_TTY=$(tty)
# https://github.com/pstadler/keybase-gpg-github
if test -f ~/.gnupg/.gpg-agent-info -a -n "$(pgrep gpg-agent)"; then
  source ~/.gnupg/.gpg-agent-info
  export GPG_AGENT_INFO
else
  eval $(gpg-agent --daemon ~/.gnupg/.gpg-agent-info)
fi

# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
# !! moved here as otherwise it didn't work ¯\_(ツ)_/¯
if test gls; then
  alias l="gls -lAh --color"
  alias ll="gls -l --color"
  alias la='gls -A --color'
  alias ls="gls -F --color"
fi

PAGER=

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# RBENV - init according to man page
if (( $+commands[rbenv] )); then
  eval "$(rbenv init -)"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# `gg` (zgen oh-my-zsh plugins/git) overwrite
# https://medium.com/darek1024/how-to-clean-local-git-branches-that-were-removed-on-the-remote-4d76f7de93ac
alias gg="git pull -p && git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}' | xargs git branch -D"
