function set-keychain-environment-variable --description 'Set a secret environment variable in the macOS keychain'
    if test -z "$argv[1]"
        return 1
    end

    read -s -P "Enter Value for $argv[1]: " secret

    if test -z "$argv[1]"; or test -z "$secret"
        return 1
    end

    security add-generic-password -U -a "$USER" -D "environment variable" -s "$argv[1]" -w "$secret"
end
