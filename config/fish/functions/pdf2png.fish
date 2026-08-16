# .pdf -> .png
# Translated from inc/functions.zsh's pdf2png().
function pdf2png --description 'PDF to PNG with Ghostscript'
    set -l file (string replace -r '\.[^.]*$' '' -- $argv[1])
    set -l outputFolder "$HOME/Desktop/$file"

    section "$argv[1] >> $outputFolder/*.png"

    if not command -sq gs
        abort "Error: Ghostscript is not installed. Install it with 'brew install ghostscript' first."
        return 1
    end

    rm -rf "$outputFolder" 2>/dev/null
    mkdir "$outputFolder" 2>/dev/null

    set -l alpha $argv[2]
    if test -z "$alpha"
        set alpha off
    end

    formatexec "magick -density 300 -colorspace sRGB '"(pwd)"/$argv[1]' -alpha $alpha '$outputFolder/$file.Page %d.png'"

    ok "PNGs saved to $PC_PATH$outputFolder$PC_RESET"
end
