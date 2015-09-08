#!/bin/zsh

source "../inc/helpers.zsh"

# DISABLED ---------------------------------------------------------------------
disabled

source "$(brew --prefix nvm)/nvm.sh"

# get default version
FILE="$HOME/.nvm/alias/default"
VERSION="v$(cat $FILE)"
SRC=$(nvm which $VERSION)
DEST="$HOME/bin/node"

# formatexec "$SRC"

# define SOURCE and TARGET
if [ -f "$SRC" ]; then
    # cleanup old symlink
    [ -f $DEST ] && formatexec "rm $DEST"

    # link it
    formatexec "ln -s $SRC $DEST"
    ok "linked %F{11}$SRC%f to %F{2}$DEST%f"
fi

# DONE & RELOAD ----------------------------------------------------------------
finished
