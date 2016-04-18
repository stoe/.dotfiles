#!/bin/zsh

nvm="${HOME}/.nvm"

[ ! -d "${nvm}" ] && mkdir "${nvm}"
[ ! -f $HOME/.npmrc ] && touch "$HOME/.npmrc" # npm config file
export NVM_DIR="${nvm}"
source "$(brew --prefix nvm)/nvm.sh"

printf "\r[ \033[00;34mnode version\033[0m ]\n"
nvm install iojs  # install latest io.js version
nvm install node  # install latest node.js version
nvm alias default node
nvm use default

# install dependencies
printf "\n\r[ \033[00;34mnode modules\033[0m ]\n"
MODS=(
    cordova phonegap ios-sim
    eslint babel babel-cli babel-eslint
    jscs jscs-jsdoc
    bower yo
    grunt-cli gulp
    mocha jasmine
    coffee-script
    cmd-plus
    dark-mode
    electron-prebuilt
    tldr
    doctoc
)

for MOD in $MODS; do
    if $(npm -g ls | grep "$MOD@[0-9\.]*$" > /dev/null 2>&1); then
        npm upgrade -g "$MOD"
        printf "upgraded \033[00;34m$MOD\033[0m\n"
    else
        npm install -g "$MOD" > /dev/null 2>&1
        printf  "installed \033[00;34m$MOD\033[0m\n"
    fi
done

npm ls -g | grep "^[└├]" | sed "s/─┬/──/g"
