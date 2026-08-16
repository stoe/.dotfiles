# Safety wrapper: move to the macOS Trash instead of unlinking.
# Backed by the `macos-trash` Homebrew formula
# (https://github.com/sindresorhus/macos-trash), which is keg-only — see
# conf.d/10-paths.fish for the PATH entry that makes it resolve first.
# Use `rm!` for the real /bin/rm.
function rm --description 'Use trash instead of rm, translated from inc/aliases.zsh'
    trash $argv
end
