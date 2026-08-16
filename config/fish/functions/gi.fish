# https://docs.gitignore.io/install/command-line
# Translated from inc/functions.zsh's gi(). Usage: gi node,macos,vscode
function gi --description 'Fetch a .gitignore template from toptal/gitignore.io'
    curl -sLw "\n" "https://www.toptal.com/developers/gitignore/api/$argv[1]"
end
