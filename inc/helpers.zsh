#!/bin/zsh

# Color variables (BOLD, GREEN, NC, …) come from inc/common.zsh, sourced first in .zshrc.

# ── Helpers ─────────────────────────────────────────────────────
abort() {
  printf '%s✘ %saborting%s %b\n\n' "$RED" "$YELLOW" "$NC" "$1"
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

  printf '%s> %s%s\n' "$DIM" "$_exec" "$NC"
  eval "$_exec"
}

ok() {
  printf '\n[ %s✓%s ] %b\n' "$GREEN" "$NC" "$1"
}

question() {
  local question="$1"
  local options="$2"

  printf '%s%b%s\n' "$BLUE" "$question" "$NC"
  [[ -n "$options" ]] && printf '%s[%s]%s\n' "$GRAY" "$options" "$NC"
}

section () {
  printf '\n[ %s%s%s ] %b\n' "$BLUE" "$1" "$NC" "$2"
}
