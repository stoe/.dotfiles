function ghup --description 'GitHub CLI extension/Copilot updater, translated from inc/functions.zsh'
    section "Updating GitHub CLI extensions"
    formatexec "gh extension upgrade --all"

    section "Updating GitHub Copilot CLI"
    formatexec "copilot update"

    section "Updating GitHub Copilot app"
    formatexec "brew upgrade --greedy --cask github-copilot-app --yes"

    ok "DONE"
end
