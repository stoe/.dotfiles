function mkd --description 'Create a new directory and enter it'
    mkdir -p $argv
    and cd $argv
end
