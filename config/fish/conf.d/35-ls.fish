# GNU coreutils `gls` overrides for the ls family.
#
# Requires `brew install coreutils`. When gls is unavailable these functions are
# not defined at all, so fish's own colorized `ls` wrapper stays in effect.
#
# Use `command -sq gls` to check availability and `--color=auto` to avoid
# injecting escape codes into pipes and redirects.

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
