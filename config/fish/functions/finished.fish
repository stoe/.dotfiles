function finished --description 'Print a signoff and reload the shell, translated from inc/helpers.zsh'
    printf '\n%s✎ with %s♥%s by %sstoe%s (https://github.com/stoe/.dotfiles)\n' "$GRAY" "$RED" "$GRAY" "$BLUE" "$NC"

    # Fish only auto-sources conf.d/*.fish at shell startup, unlike zsh's
    # simple `source ~/.zshrc` reload — exec a fresh fish process instead.
    exec fish
end
