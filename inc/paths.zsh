#### PATH & toolchain setup (array style) ######################################
# Refactored to use zsh's 'path' array for clarity, ordering, and easy de-dupe.
# Keep non-PATH environment exports (LDFLAGS, CPPFLAGS, etc.) the same.

# --- Homebrew (base prefix) ---
# Capture the main Homebrew prefix early so we can prioritize its bin dirs.
brew_prefix="$(brew --prefix 2>/dev/null)"

# --- OpenSSL ---
openssl_prefix="$(brew --prefix openssl 2>/dev/null)"
if [[ -n $openssl_prefix ]]; then
  export LDFLAGS="-L${openssl_prefix}/lib"
  export CPPFLAGS="-I${openssl_prefix}/include"
  export PKG_CONFIG_PATH="${openssl_prefix}/lib/pkgconfig"
fi

# --- OpenSSH ---
openssh_prefix="$(brew --prefix openssh 2>/dev/null)"
[[ -n $openssh_prefix ]] && export SSH_AUTH_SOCK="$(brew --prefix)/var/run/yubikey-agent.sock"

# --- Node ---
export NODE_ENV=development

# --- Go ---
export GOPATH="${HOME}/go"
export GOBIN="${GOPATH}/bin"
go_prefix="$(brew --prefix go 2>/dev/null)"
[[ -n $go_prefix ]] && export GOROOT="${go_prefix}/libexec"

# --- Build initial path array ---
# Capture original path then rebuild ensuring system dirs come first (avoid conflicts),
# followed by toolchain bins, then the prior path contents.
orig_path=("${path[@]}")
path=(
  ${brew_prefix:+${brew_prefix}/bin}      # Prefer Homebrew-provided tools first
  ${brew_prefix:+${brew_prefix}/sbin}
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  ${openssl_prefix:+${openssl_prefix}/bin}
  ${openssh_prefix:+${openssh_prefix}/bin}
  "${orig_path[@]}"
)

# --- Append additional directories ---
path+=(
  /usr/local/bin                    # legacy /usr/local (Intel / custom installs)
  /usr/local/sbin                   # sbin utilities
  "$HOME/bin"                       # user scripts
  ${GOBIN}                          # Go installed binaries
  ${GOROOT:+${GOROOT}/bin}          # Go toolchain
  $(pyenv root 2>/dev/null)/shims   # pyenv shims (if installed)
  "$HOME/.local/bin"                # uv / user-level Python tools
  "$HOME/.rbenv/bin"                # rbenv
)

# De-duplicate while keeping first occurrence
typeset -U path

# Export PATH after modifications
export PATH
