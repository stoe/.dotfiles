function o --description 'Open in Finder.app, translated from inc/functions.zsh'
    if test (count $argv) -eq 0
        open .
    else
        open $argv
    end
end
