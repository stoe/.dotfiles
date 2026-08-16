function gt --description 'Open in Tower.app, translated from inc/functions.zsh'
    if not command -sq gittower
        abort "Please install Tower.app first"
    else if test (count $argv) -eq 0
        gittower .
    else
        gittower $argv
    end
end
