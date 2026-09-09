# https://docs.gitignore.io/install/command-line
# Usage: gi node,macos,vscode
function gi --description 'Fetch a .gitignore template from toptal/gitignore.io'
    curl -sLw "\n" "https://www.toptal.com/developers/gitignore/api/$argv[1]"
end
