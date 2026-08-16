# List gh-stack branches with needsRebase status using shared helper colors.
# Translated from inc/functions.zsh's ghstackview().
function ghstackview --description 'List gh-stack branches with needsRebase status'
    if not command -sq gh
        abort "Error: gh is not installed."
        return 127
    end

    if not command -sq jq
        abort "Error: jq is not installed."
        return 127
    end

    # Shared color variables from conf.d/15-colors.fish.
    set -l color_current "$BLUE"
    set -l color_open "$GREEN"
    set -l color_true "$RED"
    set -l color_false "$GRAY"
    set -l color_reset "$NC"

    set -l rows (gh stack view --json 2>/dev/null | jq -r '.branches[] | [.name, (.needsRebase|tostring), (.isCurrent|tostring), (.pr.state // ""), (.pr.url // ""), ((.pr.number // "")|tostring)] | @tsv')

    if test -z "$rows"
        abort "No stack data found. Run this inside a gh-stack branch."
        return 1
    end

    set -l max_branch_width 0
    for row in $rows
        set -l name (string split -f1 \t -- $row)
        if test (string length -- "$name") -gt $max_branch_width
            set max_branch_width (string length -- "$name")
        end
    end

    for row in $rows
        set -l fields (string split \t -- $row)
        set -l name $fields[1]
        set -l needs $fields[2]
        set -l is_current $fields[3]
        set -l pr_state $fields[4]
        set -l pr_url $fields[5]
        set -l pr_number $fields[6]

        set -l arrow '  '
        test "$is_current" = true; and set arrow '->'

        set -l needs_color "$color_false"
        test "$needs" = true; and set needs_color "$color_true"

        set -l pr_url_color "$color_reset"
        test "$pr_state" = OPEN; and set pr_url_color "$color_open"
        test "$pr_state" = DRAFT; and set pr_url_color "$color_false"

        if test -n "$pr_url"; and test -n "$pr_number"
            set -l pr_label "#$pr_number"
            set -l pr_link_open \e\]8\;\;"$pr_url"\a
            set -l pr_link_close \e\]8\;\;\a

            if test "$is_current" = true
                printf '%s %b%-*s%b  needs rebase: %b%-5s%b  %b%b%s%b%b\n' \
                    "$arrow" "$color_current" "$max_branch_width" "$name" "$color_reset" "$needs_color" "$needs" "$color_reset" "$pr_url_color" "$pr_link_open" "$pr_label" "$pr_link_close" "$color_reset"
            else
                printf '%s %-*s  needs rebase: %b%-5s%b  %b%b%s%b%b\n' \
                    "$arrow" "$max_branch_width" "$name" "$needs_color" "$needs" "$color_reset" "$pr_url_color" "$pr_link_open" "$pr_label" "$pr_link_close" "$color_reset"
            end
        else
            if test "$is_current" = true
                printf '%s %b%-*s%b  needs rebase: %b%-5s%b\n' \
                    "$arrow" "$color_current" "$max_branch_width" "$name" "$color_reset" "$needs_color" "$needs" "$color_reset"
            else
                printf '%s %-*s  needs rebase: %b%-5s%b\n' \
                    "$arrow" "$max_branch_width" "$name" "$needs_color" "$needs" "$color_reset"
            end
        end
    end
end
