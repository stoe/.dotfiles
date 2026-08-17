# Toolchain shell hooks, translated from .zshrc's fnm/rbenv/pyenv init and gpg-agent launch.

if command -sq gpgconf; and status is-interactive
    gpgconf --launch gpg-agent >/dev/null 2>&1
end

# fnm — initialize early so its active Node bin is available to functions
# loaded later, mirroring .zshrc's placement before zgen/plugin loading.
# Quiet the startup banner so the shell prompt stays clean while preserving the
# version-selection environment setup.
if command -sq fnm
    fnm env --use-on-cd --shell fish --log-level quiet | source
end

# rbenv
if command -sq rbenv
    rbenv init - --no-rehash fish | source
end

# pyenv
if test -d "$PYENV_ROOT/bin"
    fish_add_path --append "$PYENV_ROOT/bin"
end
if command -sq pyenv
    pyenv init - fish | source
end

# direnv (kept last so its hook wraps prompt/cd behavior after everything else)
if command -sq direnv
    direnv hook fish | source
end
