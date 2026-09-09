function finished --description 'Print a signoff and reload the shell'
    printf '\n%s✎ with %s♥%s by %sstoe%s (https://github.com/stoe/.dotfiles)\n' "$GRAY" "$RED" "$GRAY" "$BLUE" "$NC"

    # Fish only auto-sources conf.d/*.fish at shell startup.
    exec fish
end
