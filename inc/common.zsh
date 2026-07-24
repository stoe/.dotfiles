#!/bin/zsh

# Shared patterns used across inc/*.zsh files.
# Sourced first in .zshrc so every include can rely on these being set.

# ── Colors (ANSI escapes) ───────────────────────────────────────
BOLD=$'\033[1m'
DIM=$'\033[2m'
GREEN=$'\033[0;32m'
BLUE=$'\033[0;34m'
YELLOW=$'\033[1;33m'
RED=$'\033[0;31m'
CYAN=$'\033[0;36m'
MAGENTA=$'\033[0;35m'
GRAY=$'\033[0;90m'
NC=$'\033[0m'

# ── Semantic roles (map to the colors above) ────────────────────
# Literal ANSI escapes, so they work with both printf and `print -P`.
PC_ANSWER="$CYAN"    # echoes the user's typed answer (e.g. `> y`)
PC_CMD="$DIM"        # echoes a command about to run (e.g. `> brew outdated`)
PC_NOTICE="$MAGENTA" # list headings (e.g. `Outdated casks:`)
PC_PATH="$YELLOW"    # highlighted file/output paths
PC_RESET="$NC"       # reset
