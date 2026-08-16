# Create a .tgz archive, using `7zz`, `pigz` or `gzip` for compression.
# Usage: targz <path>
# Translated from inc/functions.zsh's targz().
function targz --description 'Smart tar.gz creation (uses 7zz/pigz/gzip based on availability)'
    section "Compressing $argv ..."

    set -l tmp (string join ' ' $argv | string trim --right --chars=/)".tar"

    formatexec "tar -cf '$tmp' --exclude='node_modules' --exclude='.git' --exclude='.github' --exclude='.env' --exclude='.DS_Store' '$argv' || return 1"

    if command -sq 7zz
        formatexec "7zz a -tgzip '$tmp.gz' '$tmp' || return 1"
    else
        set -l cmd gzip
        if command -sq pigz
            set cmd pigz
        end

        formatexec "$cmd '$tmp' || return 1"
    end

    if test -f "$tmp"
        /bin/rm -rf "$tmp" 2>/dev/null
    end

    ok "$argv.tar.gz created successfully."
end
