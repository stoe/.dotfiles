if status is-interactive
    # GitHub CLI completion.
    if command -sq gh
        gh completion -s fish | source
    end
end
