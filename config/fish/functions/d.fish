# Directory-stack helper from Oh My Zsh's lib/directories.zsh, which .zshrc
# loaded via `zgen oh-my-zsh` (the lib, separate from the plugins).
#
# zsh built this list from AUTO_PUSHD, so `dirs -v` reflected every `cd`.
# Fish's `dirs` only tracks explicit `pushd`, so this reads $dirprev instead —
# fish's actual per-session cd history — to reproduce the original behaviour.
#
# Output is numbered most-recent-first; the number is how many steps back the
# entry is, so jump to it with `prevd N` (fish has no `cd -N`). `cd -` goes
# back one, and `cdh` offers an interactive picker.
function d --description 'List recently visited directories (Oh My Zsh lib/directories.zsh)'
    if test (count $argv) -gt 0
        dirs $argv
        return
    end

    set -l i 0
    printf '%2d  %s\n' $i (string replace -r "^$HOME" '~' -- $PWD)

    # $dirprev is oldest-first; reverse it so index 1 is the most recent.
    for dir in (for x in $dirprev; echo $x; end | tail -r | head -n 9)
        set i (math $i + 1)
        printf '%2d  %s\n' $i (string replace -r "^$HOME" '~' -- $dir)
    end
end
