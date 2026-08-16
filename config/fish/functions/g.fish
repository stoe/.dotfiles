# Companion to the `g` abbreviation in conf.d/30-git-abbr.fish.
#
# The abbreviation expands `g` -> `git` while typing interactively, which is
# the behaviour we want day to day. But abbreviations are a line-editor
# feature: they don't exist as commands, so `g` alone would fail in scripts,
# `fish -c` one-liners, and any command string that is eval'd rather than
# typed. This function covers those cases.
#
# In an interactive shell the abbreviation wins (it rewrites the line before
# execution), so this only ever runs when no expansion happened.
function g --wraps git --description 'git (non-interactive fallback for the `g` abbreviation)'
    git $argv
end
