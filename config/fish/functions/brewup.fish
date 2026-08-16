# Homebrew/Mac App Store/formulae updater with interactive or -y confirmation.
# Translated from inc/functions.zsh's brewup() (see
# https://gist.github.com/fvdm/1715d580a22503ce115c#file-homebrew_update-sh).
function brewup --description 'Interactive Homebrew/mas/cask updater (supports -y)'
    # Only allow -y flag or no arguments
    if test -n "$argv[1]"; and test "$argv[1]" != -y
        abort "Error: Only -y flag is supported."
        return 1
    end

    section "Homebrew 🍺"
    formatexec "brew --version"

    section "Updating Homebrew"
    formatexec "brew update"

    section "Casks"
    printf '%s> brew outdated --cask%s\n' "$PC_CMD" "$PC_RESET"

    set -l _cask_list (brew outdated --cask --greedy-latest --verbose | awk '{print $1}')

    if test -n "$_cask_list"
        printf '%sOutdated casks:%s\n' "$PC_NOTICE" "$PC_RESET"
        printf '%s\n' $_cask_list

        set -l ask
        if test "$argv[1]" != -y
            question "Update these casks?" "yn"
            read -s -n 1 ask
            printf '%s> %s%s\n' "$PC_ANSWER" "$ask" "$PC_RESET"
        else
            set ask y
        end

        if test "$ask" = y
            printf '%s\n' $_cask_list | xargs brew upgrade --cask --greedy-latest
        else
            ok "OK, not doing anything"
        end
    else
        ok "Nothing to do"
    end

    section "Mac App Store"
    printf '%s> mas outdated%s\n' "$PC_CMD" "$PC_RESET"

    # Mac App Store apps to skip during upgrade (id per `mas outdated`)
    set -l _mas_ignore 1596916655 # Push Security

    set -l _app_list (mas outdated)
    for _id in $_mas_ignore
        set -l _pattern "^"$_id"[[:space:]]"
        set _app_list (printf '%s\n' $_app_list | grep -v "$_pattern")
    end

    if test -n "$_app_list"
        printf '%sOutdated apps:%s\n' "$PC_NOTICE" "$PC_RESET"
        printf '%s\n' $_app_list

        set -l ask
        if test "$argv[1]" != -y
            question "Update these apps?" "yn"
            read -s -n 1 ask
            printf '%s> %s%s\n' "$PC_ANSWER" "$ask" "$PC_RESET"
        else
            set ask y
        end

        if test "$ask" = y
            printf '%s\n' $_app_list | awk '{print $1}' | xargs mas upgrade
        else
            ok "OK, not doing anything"
        end
    else
        ok "Nothing to do"
    end

    section "Formulae"
    printf '%s> brew outdated --formula%s\n' "$PC_CMD" "$PC_RESET"

    set -l _brew_list (brew outdated --formula --verbose | awk '{print $1}')

    if test -n "$_brew_list"
        printf '%sOutdated packages:%s\n' "$PC_NOTICE" "$PC_RESET"
        printf '%s\n' $_brew_list

        set -l ask
        if test "$argv[1]" != -y
            question "Update these packages?" "yn"
            read -s -n 1 ask
            printf '%s> %s%s\n' "$PC_ANSWER" "$ask" "$PC_RESET"
        else
            set ask y
        end

        if test "$ask" = y
            printf '%s\n' $_brew_list | xargs brew upgrade --formula
        else
            ok "OK, not doing anything"
        end
    else
        ok "Everything is up to date"
    end

    section "Running brew cleanup and doctor"
    formatexec "brew cleanup"
    formatexec "brew doctor"

    ok "DONE 🍻"
end
