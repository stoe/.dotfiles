function set-keychain-environment-variable --description 'Set a secret env var in the macOS keychain, translated from inc/functions.zsh (https://gist.github.com/bmhatfield/f613c10e360b4f27033761bbee4404fd)'
    if test -z "$argv[1]"
        return 1
    end

    read -s -P "Enter Value for $argv[1]: " secret

    if test -z "$argv[1]"; or test -z "$secret"
        return 1
    end

    security add-generic-password -U -a "$USER" -D "environment variable" -s "$argv[1]" -w "$secret"
end
