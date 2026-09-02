#!/usr/bin/env fish

#/ DESCRIPTION:
#/   Shared helpers sourced by script/brew/install and script/brew/cleanup.

# Resolves WORK_MACHINE_NAME / PERSONAL_MACHINE_NAME from 1Password, falling
# back to already-exported environment variables, and exports both globally
# for the sourcing script.
function _brew_resolve_machine_names
    set -l work_name "$WORK_MACHINE_NAME"
    set -l personal_name "$PERSONAL_MACHINE_NAME"

    if command -sq op
        set -l op_status (op whoami 2>&1)
        if test $status -ne 0; or string match -qi '*account is not signed in*' -- $op_status
            section "1password" "🔐 Not signed in; running 'op signin' to read machine names"
            op signin
        end

        if op whoami >/dev/null 2>&1
            set work_name (op read 'op://Private/brewfiles/WORK_MACHINE/name')
            set personal_name (op read 'op://Private/brewfiles/PERSONAL_MACHINE/name')
        end
    end

    set -g WORK_MACHINE_NAME $work_name
    set -g PERSONAL_MACHINE_NAME $personal_name
end

# Aborts with a message if the given file doesn't exist.
function _brew_require_file
    set -l path $argv[1]
    set -l label $argv[2]

    if not test -f "$path"
        abort "$label not found"
        exit 1
    end
end

# Removes a temporary Brewfile.local (+ lock) if present. `rm` is trash(1)
# here (see functions/rm.fish), which pops a Finder alert on a missing path
# instead of silently ignoring it like GNU/BSD `rm -f`, so each path is
# guarded.
function _brew_clean_local_brewfile
    set -l brewfile_local $argv[1]

    test -f "$brewfile_local"; and rm "$brewfile_local"
    test -f "$brewfile_local.lock.json"; and rm "$brewfile_local.lock.json"
end
