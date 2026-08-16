# Shared color variables, translated from inc/common.zsh.
# Sourced early (numbered before functions rely on them) so every fish
# function file can reference these globals.

set -gx BOLD \e\[1m
set -gx DIM \e\[2m
set -gx GREEN \e\[0\;32m
set -gx BLUE \e\[0\;34m
set -gx YELLOW \e\[1\;33m
set -gx RED \e\[0\;31m
set -gx CYAN \e\[0\;36m
set -gx MAGENTA \e\[0\;35m
set -gx GRAY \e\[0\;90m
set -gx NC \e\[0m

# ── Semantic roles (map to the colors above) ────────────────────
set -gx PC_ANSWER "$CYAN"    # echoes the user's typed answer (e.g. `> y`)
set -gx PC_CMD "$DIM"        # echoes a command about to run (e.g. `> brew outdated`)
set -gx PC_NOTICE "$MAGENTA" # list headings (e.g. `Outdated casks:`)
set -gx PC_PATH "$YELLOW"    # highlighted file/output paths
set -gx PC_RESET "$NC"       # reset
