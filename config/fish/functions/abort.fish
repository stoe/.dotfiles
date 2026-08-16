function abort --description 'Print an abort message in red/yellow, translated from inc/helpers.zsh'
    printf '%s✘ %saborting%s %b\n\n' "$RED" "$YELLOW" "$NC" "$argv[1]"
end
