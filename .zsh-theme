#!/bin/zsh

# based on
#   - https://github.com/andyfleming/oh-my-zsh/blob/master/themes/af-magic.zsh-theme
#   - https://github.com/andyfleming/oh-my-zsh/blob/master/themes/af-magic.zsh-theme

if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

# color vars
eval my_gray='$FG[242]'
eval my_orange='$FG[214]'

function tf_prompt_info() {
    # dont show 'default' workspace in home dir
    [[ "$PWD" == ~ ]] && return
    # check if in terraform dir
    if [ -d .terraform ]; then
      workspace=$(terraform workspace show 2> /dev/null) || return
      echo "${my_gray}tfw: $FG[105]${workspace}%{$reset_color%} "
    fi
}

function virtualenv_prompt_info(){
  [[ -n ${VIRTUAL_ENV} ]] || return
  echo "${my_gray}venv: $FG[245]${VIRTUAL_ENV:t}%{$reset_color%} "
}

# disables prompt mangling in virtual_env/bin/activate
export VIRTUAL_ENV_DISABLE_PROMPT=1

# primary prompt
PROMPT='
$FG[075]%~%{$reset_color%}
\
$(nvm_prompt_info)$(tf_prompt_info)$(virtualenv_prompt_info)$(git_prompt_info)\
$my_gray%(!.#.»)%{$reset_color%} '

PROMPT2='%{$fg[red]%}\ %{$reset_color%}'
RPS1='${return_code}'

# right prompt
RPROMPT='$my_gray%n@%m%{$reset_color%}%'

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX="${my_gray}git: $FG[078]"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="$my_orange*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=" "

# nvm settings
ZSH_THEME_NVM_PROMPT_PREFIX="${my_gray}nvm: $FG[222]"
ZSH_THEME_NVM_PROMPT_SUFFIX="%{$reset_color%} "
