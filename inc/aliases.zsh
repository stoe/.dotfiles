alias reload!='. ~/.zshrc'

# DOS style clear
alias cls="clear"

# https://github.com/sindresorhus/trash-cli
alias rm=trash
alias rm!="/bin/rm"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lsclean="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# Clean up LaunchPad
alias lpclean="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock;"

# screenshots
alias shadowon="defaults write com.apple.screencapture disable-shadow -bool false ; killall SystemUIServer"
alias shadowoff="defaults write com.apple.screencapture disable-shadow -bool true ; killall SystemUIServer"

# npm
alias npmla="npm la --depth=0"
alias npmll="npm ll --depth=0"
alias npmls="npm ls --depth=0"
# alias npx="npx --no-install $@"
alias ncua="git pull || true && ncu -i && npm i $@ && npm run format --if-present && npm run build --if-present && npm run test --if-present"
alias ncua!="git pull || true && ncu -i && rm! -rf package-lock.json yarn.lock build dist node_modules || true && npm i $@ && npm run format --if-present && npm run build --if-present && npm run test --if-present"

# act
alias act="act --container-architecture linux/amd64"

alias ghpdf="node /Users/stoe/private/@legacy/pdfify-node/index.js --header /Users/stoe/scratch/pdfify/header.hbs --style /Users/stoe/scratch/pdfify/style.css"
