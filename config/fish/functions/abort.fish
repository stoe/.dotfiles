function abort --description 'Print an abort message in red/yellow'
    printf '%s✘ %saborting%s %b\n\n' "$RED" "$YELLOW" "$NC" "$argv[1]"
end
