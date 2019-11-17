export PATH="/usr/local/bin:${PATH}"
export PATH="/usr/local/lib:${PATH}"
export PATH="/usr/local/sbin:${PATH}"

# user `bin/`
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

# Terraform
export PATH="/usr/local/opt/terraform@0.11/bin:${PATH}"
