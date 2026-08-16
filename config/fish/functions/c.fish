function c --description 'Open in Visual Studio Code.app, translated from inc/functions.zsh'
    if not command -sq code
        abort "Please install Visual Studio Code.app first"
    else if test (count $argv) -eq 0
        code .
    else
        code $argv
    end
end
