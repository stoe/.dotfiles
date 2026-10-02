function ncua --description 'npm-check-updates interactive update + build/test'
    begin
        git pull
        or true
    end
    and if npm pkg get workspaces | string match -rq '\S'
        ncu -u -w --format group
    else
        ncu -u -d --format group
    end
    and npm audit fix
    and npm install $argv
    and npm run format --if-present
    and npm run build --if-present
    and npm run test --if-present
end
