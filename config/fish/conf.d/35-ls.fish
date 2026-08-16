# GNU coreutils `gls` overrides for the ls family, translated from .zshrc.
#
# Requires `brew install coreutils`. When gls is unavailable these functions are
# not defined at all, so fish's own colorized `ls` wrapper stays in effect.
#
# Two deliberate changes from the zsh original:
#   1. The zsh guard was `if test gls` — a one-argument `test`, which is true
#      for any non-empty string, so it never actually checked for gls. Replaced
#      with a real `command -sq gls` check.
#   2. `--color` (equivalent to `--color=always`) became `--color=auto`, so
#      escape codes are no longer injected into pipes and redirects.

if command -sq gls
    function ls --description 'GNU ls with classify indicators'
        command gls -F --color=auto $argv
    end

    function l --description 'GNU ls, long format, all but . and .., human-readable sizes'
        command gls -lAh --color=auto $argv
    end

    function ll --description 'GNU ls, long format'
        command gls -l --color=auto $argv
    end

    function la --description 'GNU ls, all but . and ..'
        command gls -A --color=auto $argv
    end
end

