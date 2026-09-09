function cdf --description 'Change to the front Finder window directory'
    if not command -sq osascript
        printf 'Error: osascript is required to get the current Finder folder.\n' >&2
        return 127
    end

    set -l finder_path (command osascript \
        -e 'tell application "Finder"' \
        -e 'return POSIX path of (target of front window as alias)' \
        -e 'end tell')
    set -l osascript_status $status

    if test $osascript_status -ne 0
        printf 'Error: unable to get the current Finder folder.\n' >&2
        return $osascript_status
    end

    cd "$finder_path"
end
