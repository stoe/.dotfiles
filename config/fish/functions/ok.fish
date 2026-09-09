function ok --description 'Print a success message in green'
    printf '\n[ %s✓%s ] %b\n' "$GREEN" "$NC" "$argv[1]"
end
