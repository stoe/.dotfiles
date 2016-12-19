#!/bin/zsh
source "${HOME}/.dotfiles/inc/helpers.sh"

PWD=$(pwd -P)

cd "${HOME}/.yarn-config/global"

section "installing modules..."
formatexec "yarn global add"
ok

cd "${PWD}"
