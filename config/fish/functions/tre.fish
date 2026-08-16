function tre --description 'tree with hidden files, color, dirsfirst, piped through less; translated from inc/functions.zsh'
    tree -aC -I '.git|node_modules|bower_components|.node-gyp|compile-cache' --dirsfirst $argv | less -FRNX
end
