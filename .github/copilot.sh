#!/bin/zsh

set -e

# Source helper functions
source "$DFH/inc/helpers.zsh"

SOURCE_DIR="$HOME/Documents/.copilot"
TARGET_DIR="$DFH/.github"

# Function to remove symlinks from target directory
cleanup_old_symlinks() {
    local target_dir="$1"
    local description="$2"

    if [ ! -d "$target_dir" ]; then
        return 0
    fi

    section "CLEANUP" "Removing symlinks from %39F$target_dir%f ($description)"

    cd "$target_dir" || return 1

    # Remove symlinks (not regular files or directories)
    find . -maxdepth 1 -type l -delete 2>/dev/null || true

    ok "Cleaned up symlinks in $target_dir"
}

# Function to create flat symlinks (searches recursively but symlinks to flat directory)
create_flat_symlinks() {
    local source_dir="$1"
    local target_dir="$2"
    local file_pattern="$3"
    local description="$4"

    section "SYMLINKS" "Creating symlinks for $description from %39F$source_dir%f to %42F$target_dir%f"

    if [ ! -d "$target_dir" ]; then
        print -P "%244FTarget directory $target_dir does not exist, creating it...%f"
        mkdir -p "$target_dir"
    fi

    if [ ! -d "$source_dir" ]; then
        print -P "%244FSource directory $source_dir does not exist, skipping...%f"
        return 0
    fi

    cd "$target_dir" || {
        abort "Cannot change to target directory $target_dir"
        return 1
    }

    # Find files matching pattern recursively, excluding backup and reflections directories
    find "$source_dir" \( -type d \( -name 'backup*' -o -name 'reflections' \) -prune \) -o -type f -name "$file_pattern" -print 2>/dev/null | LC_ALL=C sort | while read -r file; do
        basename_file=$(basename "$file")

        # Create symlink if it doesn't exist
        if [ -e "$basename_file" ]; then
            print -P "%244F  Skipping $basename_file (already exists)%f"
        else
            if ln -s "$file" . 2>/dev/null; then
                ok "Linked $basename_file"
            else
                print -P "%1F  Warning: Failed to link $basename_file%f"
            fi
        fi
    done || {
        print -P "%244FNo files found matching pattern $file_pattern in $source_dir%f"
    }
}

# Function to create directory symlinks (preserves directory structure)
create_directory_symlinks() {
    local source_dir="$1"
    local target_dir="$2"
    local description="$3"

    section "SYMLINKS" "Creating directory symlinks for $description from %39F$source_dir%f to %42F$target_dir%f"

    if [ ! -d "$target_dir" ]; then
        print -P "%244FTarget directory $target_dir does not exist, creating it...%f"
        mkdir -p "$target_dir"
    fi

    if [ ! -d "$source_dir" ]; then
        print -P "%244FSource directory $source_dir does not exist, skipping...%f"
        return 0
    fi

    cd "$target_dir" || {
        abort "Cannot change to target directory $target_dir"
        return 1
    }

    # Find direct subdirectories only, excluding backup and reflections
    find "$source_dir" -maxdepth 1 -type d ! -name '.*' ! -name 'backup*' ! -name 'reflections' 2>/dev/null | LC_ALL=C sort | while read -r dir; do
        [ "$dir" = "$source_dir" ] && continue
        dirname=$(basename "$dir")

        if [ -f "$dir/.linkignore" ]; then
            print -P "%244F[ ✘ ] Skipping $dirname (.linkignore present)%f"
            continue
        fi

        # Create symlink if it doesn't exist
        if [ -e "$dirname" ]; then
            print -P "%244F  Skipping $dirname (already exists)%f"
        else
            if ln -s "$dir" . 2>/dev/null; then
                ok "Linked $dirname"
            else
                print -P "%1F  Warning: Failed to link $dirname%f"
            fi
        fi
    done || {
        print -P "%244FNo directories found in $source_dir%f"
    }
}

# Cleanup existing symlinks
cleanup_old_symlinks "$TARGET_DIR/agents" "agents"
cleanup_old_symlinks "$TARGET_DIR/instructions" "instructions"
cleanup_old_symlinks "$TARGET_DIR/prompts" "prompts"
cleanup_old_symlinks "$HOME/.copilot/skills" "skills"

# Symlink all agents (*.agent.md -> agents/) regardless of source subdirectory
create_flat_symlinks "$SOURCE_DIR" "$TARGET_DIR/agents" "*.agent.md" "agents"

# Symlink all instructions (*.instructions.md -> instructions/)
create_flat_symlinks "$SOURCE_DIR" "$TARGET_DIR/instructions" "*.instructions.md" "instructions"

# Symlink all prompts (*.prompt.md -> prompts/) regardless of source subdirectory
create_flat_symlinks "$SOURCE_DIR" "$TARGET_DIR/prompts" "*.prompt.md" "prompts"

# Symlink all skills (skills/ -> skills/) preserving directory structure into global skills directory
create_directory_symlinks "$HOME/private/skills/skills" "$HOME/.copilot/skills" "skills"

# Symlink all private skills (skills-private/ -> skills/) preserving directory structure into global skills directory
create_directory_symlinks "$HOME/private/skills-private/skills" "$HOME/.copilot/skills" "skills-private"

echo
ok "All done!"
