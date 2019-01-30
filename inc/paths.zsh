# user `bin/`
export PATH="${HOME}/bin:${PATH}"

# Ruby
export PATH="${HOME}/.rbenv/bin:${PATH}"
eval "$(rbenv init -)"

# Go
export PATH="/usr/local/opt/go/libexec/bin:${PATH}"
export GOPATH=$(go env GOPATH)
export PATH="${GOPATH}/bin:${PATH}"

# Python
export PATH="/usr/local/opt/python/libexec/bin:${PATH}"

# Travis CI
# added by travis gem
[ -f "${HOME}/.travis/travis.sh" ] && source "${HOME}/.travis/travis.sh"

# GitHub Services Training
test -f "${HOME}/.trainingmanualrc" && source "${HOME}/.trainingmanualrc"
