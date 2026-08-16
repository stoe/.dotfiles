function ci --description 'Open in Visual Studio Code Insiders.app, translated from inc/functions.zsh'
    if not command -sq code-insiders
        abort "Please install Visual Studio Code Insiders.app first"
    else if test (count $argv) -eq 0
        code-insiders .
    else
        code-insiders $argv
    end
end
