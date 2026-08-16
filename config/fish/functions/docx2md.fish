# .docx -> .md
# Usage: docx2md <input-file.docx> [output-name]
# Translated from inc/functions.zsh's docx2md().
function docx2md --description 'Word to Markdown via Pandoc'
    if not command -sq pandoc
        abort "Error: pandoc is not installed."
        return 1
    end

    if test (count $argv) -eq 0
        abort "Error: No input file specified."
        return 1
    end

    set -l inputFile $argv[1]
    set -l outputName

    if test -n "$argv[2]"
        set outputName (string replace -r '\.[^.]*$' '' -- $argv[2])
    else
        set outputName (string replace -r '\.[^.]*$' '' -- $inputFile)
    end

    set -l outputFile "$outputName.md"

    section "$argv[1] >> $outputFile"

    formatexec "pandoc -t gfm -s '$inputFile' -o '$outputFile'"

    ok "Markdown saved to $PC_PATH$outputFile$PC_RESET"
end
