# PATH assembly, translated from inc/paths.zsh's zsh `path` array.
# Fish treats PATH as a real list; use fish_add_path (idempotent, deduplicating,
# ignores nonexistent directories) instead of rebuilding an array by hand.

set -l brew_prefix (brew --prefix 2>/dev/null)
set -l openssl_prefix (brew --prefix openssl@4 2>/dev/null)
set -l openssh_prefix (brew --prefix openssh 2>/dev/null)
set -l go_prefix (brew --prefix go 2>/dev/null)

# Homebrew bin/sbin are already added by conf.d/05-homebrew.fish via `brew shellenv`.

if test -n "$openssl_prefix"
    fish_add_path --prepend "$openssl_prefix/bin"
end

if test -n "$openssh_prefix"
    fish_add_path --prepend "$openssh_prefix/bin"
end

# macos-trash is keg-only (it shadows nothing on macOS but Homebrew won't link
# it), so its bin has to be added explicitly. Prepended so `rm` -> `trash`
# resolves to the Homebrew build rather than an npm-shim copy from whichever
# Node version fnm happens to have active.
set -l macos_trash_prefix (brew --prefix macos-trash 2>/dev/null)
if test -n "$macos_trash_prefix"; and test -d "$macos_trash_prefix/bin"
    fish_add_path --prepend "$macos_trash_prefix/bin"
end

fish_add_path --append /usr/local/bin
fish_add_path --append /usr/local/sbin

# Go — GOPATH/GOBIN/GOROOT are exported here (rather than 20-environment.fish)
# since PATH assembly below depends on them.
set -gx GOPATH "$HOME/go"
set -gx GOBIN "$GOPATH/bin"
if test -n "$go_prefix"
    set -gx GOROOT "$go_prefix/libexec"
end
fish_add_path --append "$GOBIN"
if test -n "$GOROOT"
    fish_add_path --append "$GOROOT/bin"
end

# pyenv shims
if command -sq pyenv
    fish_add_path --append (pyenv root 2>/dev/null)/shims
end

fish_add_path --append "$HOME/.local/bin"    # uv / user-level Python tools
fish_add_path --append "$HOME/.rbenv/bin"    # rbenv
fish_add_path --append "$HOME/bin"           # user scripts
