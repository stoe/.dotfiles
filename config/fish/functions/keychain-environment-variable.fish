function keychain-environment-variable --description 'Get a secret environment variable from the macOS keychain'
    security find-generic-password -w -a "$USER" -D "environment variable" -s "$argv[1]"
end
