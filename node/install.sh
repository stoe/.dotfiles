#!/bin/zsh
source "$HOME/.dotfiles/inc/helpers.sh"

nvm="${HOME}/.nvm"

[ ! -d "${nvm}" ] && mkdir "${nvm}"
[ ! -f "$HOME/.npmrc" ] && touch "$HOME/.npmrc" # npm config file
export NVM_DIR="${nvm}"
source "$(brew --prefix nvm)/nvm.sh"

# node versions
section "node version"

formatexec "nvm install iojs"  # install latest io.js version
formatexec "npm install -g npm@latest"

formatexec "nvm install node"  # install latest node.js version
formatexec "npm install -g npm@latest"

formatexec "nvm alias default node"
formatexec "nvm use default"

section "installed node versions"
formatexec "nvm ls"
echo

# modules
section "node modules"

question "Do you want to reinstall prior packages?" "Yn"
read _reinstall

if [[ "$_reinstall" == "y" || "$_reinstall" == "" ]]; then
  # reinstall packages
  question "From which version?"
  read _NODE_VERSION

  formatexec "nvm reinstall-packages v${_NODE_VERSION}"
else
  # install dependencies
  MODS=(
      azure-cli
      yarn
  )

  for MOD in $MODS; do
    if $(npm -g ls | grep "$MOD@[0-9\.]*$" > /dev/null 2>&1); then
        formatexec "npm upgrade -g $MOD"
        print -P "  └ %F{3}upgraded%f"
    else
        formatexec "npm install -g $MOD > /dev/null 2>&1"
        print -P "  └ %F{2}installed%f"
    fi
  done
fi

echo

formatexec "npm ls -g | grep \"^[└├]|\" | sed \"s/─┬/──/g\""

ok
