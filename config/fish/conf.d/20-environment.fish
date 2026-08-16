# Non-PATH environment exports, translated from inc/paths.zsh and .zshrc.
# GOPATH/GOBIN/GOROOT are set in conf.d/10-paths.fish since PATH depends on them.

# Locale, from .zshrc.
set -gx LC_CTYPE en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8

set -l openssl_prefix (brew --prefix openssl@4 2>/dev/null)
if test -n "$openssl_prefix"
    set -gx LDFLAGS "-L$openssl_prefix/lib"
    set -gx CPPFLAGS "-I$openssl_prefix/include"
    set -gx PKG_CONFIG_PATH "$openssl_prefix/lib/pkgconfig"
end

set -gx NODE_ENV development

set -gx PYENV_ROOT "$HOME/.pyenv"

# SSH agent (1Password) — standardized here instead of yubikey-agent/ssh-agent
# to avoid multiple agents racing to own SSH_AUTH_SOCK.
set -gx SSH_AUTH_SOCK "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

set -gx EDITOR "code-insiders --wait"
set -gx VISUAL "$EDITOR"
set -gx GIT_EDITOR "$EDITOR"

if status is-interactive
    set -gx GPG_TTY (tty)
end
