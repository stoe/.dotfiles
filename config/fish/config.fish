if status is-interactive
    # GitHub CLI completion (replaces .zshrc's `eval "$(gh completion -s zsh)"`)
    if command -sq gh
        gh completion -s fish | source
    end
end

