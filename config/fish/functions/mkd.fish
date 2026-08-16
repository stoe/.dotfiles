function mkd --description 'Create a new directory and enter it, translated from inc/functions.zsh'
    mkdir -p $argv
    and cd $argv
end
