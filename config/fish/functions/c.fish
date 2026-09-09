function c --description 'Open in Visual Studio Code.app'
    if not command -sq code
        abort "Please install Visual Studio Code.app first"
    else if test (count $argv) -eq 0
        code .
    else
        code $argv
    end
end
