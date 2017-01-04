#!/bin/zsh
source "${HOME}/.dotfiles/inc/helpers.sh"

PWD=$(pwd -P)

cd "${HOME}/.config/yarn/global"

section "installing modules..."
formatexec "yarn global add"
formatexec "yarn global ls"
ok

cd "${PWD}"
