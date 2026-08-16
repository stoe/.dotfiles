function question --description 'Print a question (and optional options hint), translated from inc/helpers.zsh'
    set -l question $argv[1]
    set -l options $argv[2]

    printf '%s%b%s\n' "$BLUE" "$question" "$NC"
    test -n "$options"; and printf '%s[%s]%s\n' "$GRAY" "$options" "$NC"
end
