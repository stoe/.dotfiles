function keychain-environment-variable --description 'Get a secret env var from the macOS keychain, translated from inc/functions.zsh (https://www.netmeister.org/blog/keychain-passwords.html)'
    security find-generic-password -w -a "$USER" -D "environment variable" -s "$argv[1]"
end
