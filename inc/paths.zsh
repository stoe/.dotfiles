# OpenSSL
export PATH="$(brew --prefix openssl)/bin:${PATH}"
export LDFLAGS="-L$(brew --prefix openssl)/lib"
export CPPFLAGS="-I$(brew --prefix openssl)/include"
export PKG_CONFIG_PATH="$(brew --prefix openssl)/lib/pkgconfig"

# OpenSSH
export PATH="$(brew --prefix openssh)/bin:${PATH}"
export SSH_AUTH_SOCK="$(brew --prefix)/var/run/yubikey-agent.sock"

# bin
export PATH="${PATH}:/usr/local/bin"
export PATH="${PATH}:/usr/local/lib"
export PATH="${PATH}:/usr/local/sbin"
export PATH="${PATH}:${HOME}/bin"

# Node
export NODE_ENV=development

# Go
export GOPATH="${HOME}/.go"
export GOBIN="${GOPATH}/bin"
export PATH="${PATH}:${GOBIN}"
export GOROOT="/usr/local/opt/go/libexec"
export PATH="${PATH}:${GOROOT}/bin"

# Python
export PATH="${PATH}:/usr/local/opt/python/libexec/bin"

# Ruby
# export PATH="${PATH}:${HOME}/.rbenv/bin"
eval "$(rbenv init -)"
# export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl)"

# MySQL
export PATH="${PATH}:$(brew --prefix)/opt/mysql@5.7/bin"

# Azure
export PATH="${PATH}:$(brew --prefix)/bin/func"
export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1
