# Git abbreviations, replacing the Oh My Zsh `git` plugin's aliases that were
# loaded via zgen in .zshrc. Only the subset actually used is carried over
# (verified against ~/.zsh_history), plus their closest siblings.
#
# Abbreviations rather than functions/aliases so the expansion is visible in
# the command line before running — fish's idiomatic equivalent of an alias.
#
# Deliberately NOT defined: `gs`, `gls` and `gcp`, which on this machine resolve to
# ghostscript, coreutils' gls and coreutils' gcp (cp) respectively, not to git.

if status is-interactive
    # git itself — the most-used abbreviation of the lot. Also backed by a
    # real function in functions/g.fish, since abbreviations don't expand in
    # scripts or `fish -c`; the rest below are interactive-only by design.
    abbr -a g git

    # add
    abbr -a ga git add
    abbr -a gaa git add --all
    abbr -a gapa git add --patch

    # commit
    # .zshrc deliberately overrode the omz git plugin's `gc` with gitmoji;
    # preserved here. `gc!`/`gcn!` remain plain git amend commands.
    if command -sq gitmoji
        abbr -a gc gitmoji -c
    else
        abbr -a gc git commit --verbose
    end
    abbr -a 'gc!' git commit --verbose --amend
    abbr -a 'gcn!' git commit --verbose --no-edit --amend
    abbr -a gcam git commit --all --message
    abbr -a gcs git commit --gpg-sign

    # branch / checkout / switch
    abbr -a gb git branch
    abbr -a gbd git branch --delete
    abbr -a gbD git branch --delete --force
    abbr -a gco git checkout
    abbr -a gcb git checkout -b
    abbr -a gsw git switch
    abbr -a gswc git switch --create

    # diff
    abbr -a gd git diff
    abbr -a gdca git diff --cached

    # fetch / pull / push
    abbr -a gfa git fetch --all --tags --prune --jobs=10
    abbr -a gl git pull
    abbr -a gp git push
    abbr -a gpd git push --dry-run
    abbr -a gpf git push --force-with-lease --force-if-includes
    abbr -a 'gpf!' git push --force

    # rebase
    abbr -a grb git rebase
    abbr -a grbi git rebase --interactive
    abbr -a grbc git rebase --continue
    abbr -a grba git rebase --abort

    # stash
    abbr -a gsta git stash push
    abbr -a gstp git stash pop

    # misc
    abbr -a gcl git clone --recurse-submodules
    abbr -a gm git merge
end
