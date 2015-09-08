#!/bin/zsh

source "../inc/helpers.zsh"

# DISABLED ---------------------------------------------------------------------
disabled

print -P "uninstalling %F{11}~/%f"

# BREW -------------------------------------------------------------------------
section "brew"

# casks
for CASK in $(brew cask list); do
    formatexec "brew cask zap $CASK > /dev/null 2>&1"
    print -P "%F{1}✗%f cask %F{4}$CASK%f removed"
done

# brews
for BREW in $(brew list); do
    formatexec "brew uninstall $BREW > /dev/null 2>&1"
    print -P "%F{1}✗%f %F{4}$BREW%f removed"
done

formatexec "brew prune"
formatexec "brew cleanup"

formatexec "ruby -e \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)\""

formatexec "sudo chmod 0755 /usr/local"
formatexec "sudo chgrp wheel /usr/local"

ok

# ANTIGEN ----------------------------------------------------------------------
section "antigen"

[ -d "~/.antigen" ] && formatexec "rm -rf ~/.antigen"

ok

# DONE & RELOAD ----------------------------------------------------------------
finished
