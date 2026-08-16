function ncua --description 'npm-check-updates interactive update + build/test, translated from inc/aliases.zsh'
    begin
        git pull
        or true
    end
    and ncu --interactive --format group
    and npm install $argv
    and npm run format --if-present
    and npm run build --if-present
    and npm run test --if-present
end
