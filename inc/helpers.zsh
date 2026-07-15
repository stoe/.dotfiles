#!/bin/zsh

# ── Colors ──────────────────────────────────────────────────────
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

# ── Helpers ─────────────────────────────────────────────────────
abort() {
  printf '%s✘ %saborting%s %s\n\n' "$RED" "$YELLOW" "$NC" "$1"
  return
}

disabled() {
  printf '%sdisabled%s\n\n' "$RED" "$NC"
  return 0
}

finished() {
  printf '\n%s✎ with %s♥%s by %sstoe%s (https://github.com/stoe/.dotfiles)\n' "$GRAY" "$RED" "$GRAY" "$BLUE" "$NC"

  source "$HOME/.zshrc"
}

formatexec() {
  local _exec="$1"

  printf '%s> %s%s\n' "$GRAY" "$_exec" "$NC"
  eval "$_exec"
}

ok() {
  printf '\n[ %s✓%s ] %s\n' "$GREEN" "$NC" "$1"
}

question() {
  local question="$1"
  local options="$2"

  printf '%s%s%s\n' "$BLUE" "$question" "$NC"
  [[ -n "$options" ]] && printf '%s[%s]%s\n' "$GRAY" "$options" "$NC"
}

section () {
  printf '\n[ %s%s%s ] %s\n' "$MAGENTA" "$1" "$NC" "$2"
}
