# load nvm
nvm="$HOME/.nvm"

[ ! -d "${nvm}" ] && mkdir "${nvm}"
[ ! -f "$HOME/.npmrc" ] && touch $HOME/.npmrc     # npm config file
export NVM_DIR="${nvm}"
source "$(brew --prefix nvm)/nvm.sh"
eval "$(nodenv init -)"
