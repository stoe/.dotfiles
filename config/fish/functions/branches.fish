# List branches while honoring Git's `log.excludeDecoration` entries.
#
# This keeps the shell-side behavior in sync with the repository configuration,
# without hard-coding the Copilot refs in fish itself.
function branches --description 'List branches, honoring git log.excludeDecoration'
    set -l color_flag --color=always
    if not status is-interactive
        set color_flag --color=never
    end

    set -l exclusions (git config --get-all log.excludeDecoration 2>/dev/null)
    if test -z "$exclusions"
        git branch -avv $color_flag
        return
    end

    git branch -avv $color_flag | while read -l line
        set -l skip 0

        for exclusion in $exclusions
            set -l trimmed (string replace -r '^refs/' '' -- "$exclusion")
            if string match -q -- "*$trimmed*" "$line"
                set skip 1
                break
            end
        end

        if test $skip -eq 0
            printf '%s\n' "$line"
        end
    end
end
