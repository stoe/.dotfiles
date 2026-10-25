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
            section 1password "🔐 Not signed in; running 'op signin' to read machine names"
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

# Records the "section › category" label of every active Brewfile entry. The
# section comes from `#/ section ---` lines; the category from a `# Category`
# comment that directly follows a blank line, so inline notes and
# commented-out entries are not mistaken for categories.
function _brew_load_categories
    set -g _brew_category_names
    set -g _brew_category_keys
    set -g _brew_category_labels

    for brewfile in $argv
        set -l section
        set -l category
        set -l previous ''

        while read -l line
            if string match -qr '^#/' -- "$line"
                set -l title (string replace -r '^#/\s*' '' -- "$line" \
                    | string replace -r '\s*-+$' '' \
                    | string replace -r '^brew ' '' \
                    | string replace -r '^\((\w+)\) ' '$1 ')
                if test -n "$title"
                    set section $title
                    set category
                end
            else if string match -qr '^#' -- "$line"
                if test -z "$previous"
                    and not string match -qr '^#\s*(tap|brew|cask|mas|vscode|cleanup-ignore-app)\s' -- "$line"
                    set category (string replace -r '^#\s*' '' -- "$line")
                end
            else
                set -l name (string match -rg '^\s*(?:tap|brew|cask|mas|vscode)\s+"([^"]+)"' -- "$line")
                if test -n "$name"
                    set -a _brew_category_names $name
                    set -a _brew_category_keys (string lower -- $name)
                    set -a _brew_category_labels (string join ' › ' -- $section $category)
                end
            end
            set previous $line
        end <$brewfile
    end
end

# Prints the category label of the entry that the given text starts with,
# preferring the longest match so "1Password for Safari" beats "1password".
function _brew_category_label
    set -l text (string lower -- "$argv[1]")
    set -l best 0
    set -l best_length 0

    for index in (seq (count $_brew_category_keys))
        set -l key $_brew_category_keys[$index]
        set -l key_length (string length -- "$key")
        test $key_length -gt $best_length; or continue

        if test "$text" = "$key"
            or test (string sub -l (math $key_length + 1) -- "$text") = "$key "
            set best $index
            set best_length $key_length
        end
    end

    test $best -gt 0; or return 1
    printf '%s\n' $_brew_category_labels[$best]
end

# The optional second argument overrides the line ending (see
# _brew_annotate_categories).
function _brew_category_heading
    set -l eol \n
    set -q argv[2]; and set eol $argv[2]
    printf '%s── %s%s%s' "$BLUE" "$argv[1]" "$NC" "$eol"
end

# Passes output through, printing a category heading whenever a
# "Using/Installing/Upgrading/Tapping/Skipping <entry>" line, or a
# `brew bundle check --verbose` "→ <Type> <entry> needs to be ..." line,
# starts a new one. Pass "--raw" while script(1) holds the terminal in raw
# mode: a bare \n then no longer returns to column 0, so lines end in \r\n.
function _brew_annotate_categories
    set -l current
    set -l eol \n
    test "$argv[1]" = --raw; and set eol \r\n

    while read -l line
        set line (string replace -r '\r$' '' -- "$line")
        set -l plain (string replace -ra '\e\[[0-9;?]*[A-Za-z]|\r' '' -- "$line")
        set -l entry (string match -rg '^(?:Using|Installing|Upgrading|Tapping|Skipping)\s+(.+)$' -- "$plain")
        or set entry (string match -rg '^→\s+\S+\s+(.+?)\s+needs to be\b' -- "$plain")

        if test -n "$entry"
            set -l label (_brew_category_label "$entry")
            if test -n "$label"; and test "$label" != "$current"
                set current $label
                _brew_category_heading $label $eol
            end
        end

        printf '%s%s' "$line" "$eol"
    end
end

# Runs a command with category headings added to its output. On a terminal
# it runs under script(1): Homebrew only line-buffers piped output under CI,
# and a pseudo-terminal also keeps its colors and progress output.
function _brew_run_with_categories
    printf '%s> %s%s\n' "$DIM" "$argv" "$NC"

    set -l result
    if test -t 0; and test -t 1
        script -q /dev/null $argv | _brew_annotate_categories --raw
        set result $pipestatus[1]
    else
        $argv 2>&1 | _brew_annotate_categories
        set result $pipestatus[1]
    end

    return $result
end

# Prints every loaded entry grouped under its category heading.
function _brew_print_category_overview
    set -l total (count $_brew_category_names)
    test $total -gt 0; or return 0

    set -l start 1
    for index in (seq $total)
        set -l next (math $index + 1)
        if test $index -eq $total
            or test "$_brew_category_labels[$next]" != "$_brew_category_labels[$index]"
            _brew_category_heading $_brew_category_labels[$index]
            printf '   %s\n' (string join ', ' -- $_brew_category_names[$start..$index])
            set start $next
        end
    end
end
