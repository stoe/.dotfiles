# OpenSSL
export PATH="${PATH}:/usr/local/opt/openssl@1.1/bin"
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"

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
export PATH="${PATH}:${HOME}/.rbenv/bin"
eval "$(rbenv init -)"
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

# MySQL
export PATH="${PATH}:$(brew --prefix)/opt/mysql@5.7/bin"

# Azure
export PATH="${PATH}:$(brew --prefix)/bin/func"
export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1

# Terraform
export PATH="${PATH}:/usr/local/opt/terraform@0.13/bin"
