#!/bin/zsh

set -e

# Source helper functions
source "$DFH/inc/helpers.zsh"

SOURCE_DIR="$HOME/Documents/.copilot"
TARGET_DIR="$DFH/.github"

# Function to safely create symlinks
create_symlinks() {
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

    # Find and symlink files, allowing individual failures
    local linked_count=0
    find "$source_dir" \( -type d -name backup -prune \) -o -type f -name "$file_pattern" -print 2>/dev/null | while read -r file; do
        basename_file=$(basename "$file")
        if [ -e "$basename_file" ]; then
            print -P "%244F  Skipping $basename_file (already exists)%f"
        else
            if ln -s "$file" . 2>/dev/null; then
                ok "Linked $basename_file"
                linked_count=$((linked_count + 1))
            else
                print -P "%1F  Warning: Failed to link $basename_file%f"
            fi
        fi
    done || {
        print -P "%244FNo files found matching pattern $file_pattern in $source_dir%f"
    }
}

# Symlink all agents
create_symlinks "$SOURCE_DIR/agents" "$TARGET_DIR/agents" "*.agent.md" "agents"

# Symlink all instructions
create_symlinks "$SOURCE_DIR/instructions" "$TARGET_DIR/instructions" "*.instructions.md" "instructions"

# Symlink all prompts
create_symlinks "$SOURCE_DIR/prompts" "$TARGET_DIR/prompts" "*.prompt.md" "prompts"

# Symlink all toolsets
create_symlinks "$DFH/.github/toolsets" "$HOME/Library/Application Support/Code/User/prompts" "*.jsonc" "toolsets"

echo
ok "All done!"
