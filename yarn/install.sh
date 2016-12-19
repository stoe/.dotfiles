#!/bin/zsh
source "${HOME}/.dotfiles/inc/helpers.sh"

PWD=$(pwd -P)

cd "${HOME}/.yarn-config/global"

section "installing..."
formatexec "yarn global add"
formatexec "yarn global ls"
ok

cd "${PWD}"
