# One-time Tide prompt configuration, mapped from .p10k.zsh's lean/sparse/
# disconnected/few-icon two-line style (dir+vcs / newline / prompt_char left;
# status/cmd_duration/jobs/direnv/toolchain-version/cloud-CLI segments right).
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

    # p10k parity: os_icon was commented out/disabled in .p10k.zsh, so drop
    # Tide's default `os` segment from the left prompt (dir + git only).
    set -U tide_left_prompt_items pwd git newline character
end
