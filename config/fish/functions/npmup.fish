# NPM global package updater with confirmation, translated from
# inc/functions.zsh's npmup() (see npm outdated/update/doctor docs).
function npmup --description 'NPM global package updater with confirmation (supports -y)'
    # Only allow -y flag or no arguments
    if test -n "$argv[1]"; and test "$argv[1]" != -y
        abort "Error: Only -y flag is supported."
        return 1
    end

    section "Updating NPM global packages"
    printf '%s> npm outdated --global%s\n' "$PC_CMD" "$PC_RESET"

    set -l packages (npm outdated --global --depth=0 | grep global | wc -l | awk '{print $1}')

    if test "$packages" != 0
        printf '%sOutdated packages:%s %s\n' "$PC_NOTICE" "$PC_RESET" "$packages"
        npm outdated --global --depth=0

        set -l ask
        if test "$argv[1]" != -y
            question "Update these packages?" "yn"
            read -s -n 1 ask
            printf '%s> %s%s\n' "$PC_ANSWER" "$ask" "$PC_RESET"
        else
            set ask y
        end

        if test "$ask" = y
            formatexec "npm update --global --omit=dev --omit=optional --omit=peer --depth=0 --install-strategy=shallow"
        else
            ok "OK, not doing anything"
        end
    else
        ok "Everything is up to date"
    end

    if command -sq fnm
        set -l fnm_current_version (fnm current 2>/dev/null)

        if test -n "$fnm_current_version"; and test "$fnm_current_version" != system; and test "$fnm_current_version" != none
            set -l fnm_dir (set -q FNM_DIR; and echo $FNM_DIR; or echo "$HOME/.local/share/fnm")
            set -l fnm_node_bin "$fnm_dir/node-versions/$fnm_current_version/installation/bin"

            if test -d "$fnm_node_bin"
                fish_add_path --prepend "$fnm_node_bin"
            end
        end
    end

    formatexec "npm doctor ping registry environment cache"

    ok "Node\t"(node --version)
    ok "NPM\tv"(npm --version)

    ok "DONE"
end
