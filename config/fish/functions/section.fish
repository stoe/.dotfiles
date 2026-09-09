function section --description 'Print a section heading'
    printf '\n[ %s%s%s ] %b\n' "$BLUE" "$argv[1]" "$NC" "$argv[2]"
end
