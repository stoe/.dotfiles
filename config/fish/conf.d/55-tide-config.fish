# One-time Tide prompt configuration using a compact, disconnected two-line style.
# Guarded so it only runs once per machine (fresh `tide_left_prompt_items` is
# unset until `tide configure` has run) instead of re-running interactively
# on every shell start.
if status is-interactive; and functions -q tide; and not set -q tide_left_prompt_items
    tide configure --auto \
        --style=Lean \
        --prompt_colors="True color" \
        --show_time=No \
        --lean_prompt_height="Two lines" \
        --prompt_connection=Disconnected \
        --prompt_spacing=Compact \
        --icons="Many icons" \
        --transient=Yes

    # Keep the left prompt focused on the directory and Git state.
    set -U tide_left_prompt_items pwd git newline character
end
