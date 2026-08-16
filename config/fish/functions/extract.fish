# Extract any archive.
# Usage: extract <file>
# Translated from inc/functions.zsh's extract().
function extract --description 'Universal archive extractor for multiple formats'
    if test (count $argv) -ne 1
        abort "Error: No file specified."
        return 1
    end

    set -l file $argv[1]

    if test -f "$file"
        switch $file
            case '*.tar.bz2'
                formatexec "pv '$file' | tar xjf -"
            case '*.tar.gz'
                formatexec "pv '$file' | tar xzf -"
            case '*.bz2'
                formatexec "bunzip2 '$file'"
            case '*.rar'
                formatexec "unrar x '$file'"
            case '*.gz'
                formatexec "gunzip '$file'"
            case '*.tar'
                formatexec "pv '$file' | tar xf -"
            case '*.tbz2'
                formatexec "pv '$file' | tar xjf -"
            case '*.tgz'
                formatexec "pv '$file' | tar xzf -"
            case '*.zip'
                formatexec "unzip '$file'"
            case '*.Z'
                formatexec "uncompress '$file'"
            case '*'
                abort "'$file' cannot be extracted via extract"
        end
    else
        abort "'$file' is not a valid file"
    end
end
