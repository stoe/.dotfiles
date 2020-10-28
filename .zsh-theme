#!/bin/zsh

# based on
#   - https://github.com/andyfleming/oh-my-zsh/blob/master/themes/af-magic.zsh-theme

# color vars
eval red='$fg[red]'
eval green='$fg[green]'
eval yellow='$fg[yellow]'
eval blue='$fg[blue]'
eval magenta='$fg[magenta]'
eval cyan='$fg[cyan]'
eval white='$fg[white]'
# eval grey='$fg[grey]'

eval grey='$FG[242]'
eval orange='$FG[214]'
eval purple='$FG[141]'

if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
local return_code="%(?..%{$red%}%? ↵%{$reset_color%})"

function tf_prompt_info() {
  [[ $(which terraform) =~ "not found" ]] && return

  # dont show 'default' workspace in home dir
  [[ "$PWD" == ~ ]] && return

  # check if in terraform dir
  if [ -d .terraform ]; then
    workspace=$(terraform workspace show 2> /dev/null) || return

    setopt local_options BASH_REMATCH

    local version=$(terraform version | awk 'NR==1{print $2}')
    local regex="([0-9]{1,2}.[0-9]{1,2}[.[0-9]{1,3}]?)"

    if [[ $version =~ $regex ]]; then
      echo "%{$grey%}tfw(%{$purple%}${BASH_REMATCH[1]}%{$grey%},%{$purple%}${workspace}%{$grey%})%{$reset_color%} "
    else
      echo "%{$grey%}tfw(%{$purple%}${workspace}%{$grey%})%{$reset_color%} "
    fi
  fi
}

function virtualenv_prompt_info(){
  [[ -n ${VIRTUAL_ENV} ]] || return
  echo "%{$grey%}venv(%{$magenta%}${VIRTUAL_ENV:t}%{$grey%})%{$reset_color%} "
}

function golang_prompt_info {
  [[ $(which go) =~ "not found" ]] && return

  setopt local_options BASH_REMATCH

  local version=$(go version)
  local regex="([0-9]{1,2}.[0-9]{1,2}[.[0-9]{1,2}]*)"

  if [[ $version =~ $regex ]]; then
    echo "%{$grey%}go(%{$cyan%}${BASH_REMATCH[1]}%{$grey%})%{$reset_color%} "
  fi
}

function gitversion_prompt_info {
  [[ $(which git) =~ "not found" ]] && return

  setopt local_options BASH_REMATCH

  local version=$(git --version)
  local regex="([0-9]{1,2}.[0-9]{1,2}[.[0-9]{1,2}]*)"

  if [[ $version =~ $regex ]]; then
    echo "%{$grey%}git(%{$blue%}${BASH_REMATCH[1]}%{$grey%})%{$reset_color%} "
  fi
}

# disables prompt mangling in virtual_env/bin/activate
export VIRTUAL_ENV_DISABLE_PROMPT=1

# primary prompt
PROMPT='
%{$grey%}%n@%m%{$reset_color%} $(gitversion_prompt_info)$(golang_prompt_info)$(nvm_prompt_info)$(tf_prompt_info)$(virtualenv_prompt_info)
\
%{$blue%}%1~%{$reset_color%}$(git_prompt_info) $grey%(!.#.$)%{$reset_color%} '

PROMPT2='%{$red%}\ %{$reset_color%}'
RPS1='${return_code}'

# right prompt
# RPROMPT='%{$grey%}%n@%m%{$reset_color%}%'

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX="%{$grey%}[%{$yellow%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$orange%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$grey%}]%{$reset_color%}"

# nvm settings
ZSH_THEME_NVM_PROMPT_PREFIX="%{$grey%}nvm(%{$green%}"
ZSH_THEME_NVM_PROMPT_SUFFIX="%{$grey%})%{$reset_color%} "
