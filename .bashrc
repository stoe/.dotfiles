#!/bin/bash

# -- Source dependencies

# source .bashrc-local if it exists
if [ -f ~/.bashrc-local ]; then
  source ~/.bashrc-local
fi

# Get it from the original Git repo:
# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
if [ -f ~/.git-prompt.sh ]; then
  source ~/.git-prompt.sh
fi

# # Get it from the original Git repo:
# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
if [ -f ~/.git-completion.bash ]; then
  source ~/.git-completion.bash
fi

# -- Aliases

alias l="ls -lAh"
alias ll="ls -Gl"
alias la='ls -GA'
alias ls="ls -GpF"

alias g=git
# Reload the shell
alias reload!='. ~/.bashrc'
# DOS style clear
alias cls="clear"

# load GitHub Copilot aliases
eval "$(gh copilot alias -- bash)"

# -- Prompt

export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true
# export GIT_PS1_SHOWUNTRACKEDFILES=true

# If we don't use the below git master one, use this simple
# PS1="\[$(tput setaf 6)\]\W\[$(tput sgr0)\]\[$(tput sgr0)\] \$ "

# 1. Git branch is being showed
# 2. Title of terminal is changed for each new shell
# 3. History is appended each time
export PROMPT_COMMAND='__git_ps1 "\[$(tput setaf 6)\]\W\[$(tput sgr0)\]\[$(tput sgr0)\]" "\n» "; echo -ne "\033]0;${PWD##*/}\007"'

# -- History

# ignoreboth ignores commands starting with a space and duplicates. Erasedups
# removes all previous dups in history
export HISTCONTROL=ignoreboth:erasedups
export HISTFILE=~/.bash_history          # be explicit about file path
export HISTSIZE=100000                   # in memory history size
export HISTFILESIZE=100000               # on disk history size
export HISTTIMEFORMAT='%F %T '
shopt -s histappend # append to history, don't overwrite it
shopt -s cmdhist    # save multi line commands as one command

# Save multi-line commands to the history with embedded newlines
# instead of semicolons -- requries cmdhist to be on.
shopt -s lithist
