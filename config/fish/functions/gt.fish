function gt --description 'Open in Tower.app'
    if not command -sq gittower
        abort "Please install Tower.app first"
    else if test (count $argv) -eq 0
        gittower .
    else
        gittower $argv
    end
end
