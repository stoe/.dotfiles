function ok --description 'Print a success message in green, translated from inc/helpers.zsh'
    printf '\n[ %s✓%s ] %b\n' "$GREEN" "$NC" "$argv[1]"
end
