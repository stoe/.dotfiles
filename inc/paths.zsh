# OpenSSL
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

# bin
export PATH="/usr/local/bin:${PATH}"
export PATH="/usr/local/lib:${PATH}"
export PATH="/usr/local/sbin:${PATH}"
export PATH="${HOME}/bin:${PATH}"

# Go
export GOPATH="${HOME}/.go"
export GOBIN="${GOPATH}/bin"

export PATH="/usr/local/opt/go/libexec/bin:${PATH}"
export PATH="${GOBIN}:${PATH}"

# Python
export PATH="/usr/local/opt/python/libexec/bin:${PATH}"

# Ruby
export PATH="${HOME}/.rbenv/bin:${PATH}"
eval "$(rbenv init -)"
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

# MySQL
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

# Google Cloud
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
