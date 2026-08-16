function disabled --description 'Print a disabled message in red, translated from inc/helpers.zsh'
    printf '%sdisabled%s\n\n' "$RED" "$NC"
    return 0
end
