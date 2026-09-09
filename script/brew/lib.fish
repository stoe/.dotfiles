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

# Reports installed fish version(s), for diffing before/after a brew
# operation that may add or remove a Cellar version.
function _brew_fish_version
    brew list --versions fish 2>/dev/null
end

# Warns when fish's installed version(s) changed: any already-running fish
# shell keeps a stale `status fish-path` (Tide's `fish_prompt.fish` embeds it
# via `eval`) pointing at the now-gone Cellar dir until the shell is
# restarted.
function _brew_warn_if_fish_changed
    set -l before $argv[1]
    set -l after $argv[2]

    if test -n "$before"; and test "$before" != "$after"
        printf '\n\033[38;5;220m⚠ fish was updated (%s → %s). Restart your shell (`exec fish` or a new terminal tab) to avoid stale fish-path errors in the prompt.\033[0m\n' \
            (string replace 'fish ' '' -- $before) (string replace 'fish ' '' -- $after)
    end
end
