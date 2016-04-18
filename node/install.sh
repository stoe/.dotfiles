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

# install dependencies
section "node modules"
MODS=(
    eslint babel babel-cli babel-eslint
    bower yo
    grunt-cli gulp
    mocha jasmine
    coffee-script
    dark-mode
    electron-prebuilt
    tldr
    doctoc
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

echo

formatexec "npm ls -g | grep \"^[└├]|\" | sed \"s/─┬/──/g\""

ok
