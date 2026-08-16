function ncua! --description 'npm-check-updates full upgrade + clean reinstall, translated from inc/aliases.zsh'
    begin
        git pull
        or true
    end
    and ncu -i
    and begin
        rm! -rf package-lock.json yarn.lock build dist node_modules
        or true
    end
    and npm i $argv
    and npm run format --if-present
    and npm run build --if-present
    and npm run test --if-present
end
