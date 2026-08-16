function formatexec --description 'Echo then eval a command, translated from inc/helpers.zsh'
    set -l _exec $argv[1]

    printf '%s> %s%s\n' "$DIM" "$_exec" "$NC"
    eval "$_exec"
end
