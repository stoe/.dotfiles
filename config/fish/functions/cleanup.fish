function cleanup --description 'Recursively delete .DS_Store files, translated from inc/aliases.zsh'
    find "$PWD" \( -path "$HOME/Library/CloudStorage" -o -path "$HOME/Library/CloudStorage/*" \) -prune -o -type f -name "*.DS_Store" -ls -delete
end
