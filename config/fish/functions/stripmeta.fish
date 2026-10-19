# Remove all metadata (EXIF/IPTC/XMP) from one or more image files, in place.
# Non-PNG files are converted to PNG first (when ImageMagick is available) so
# exiftool never has to drop an ICC profile from a lossy format.
# Display a colored before/after diff of grouped device/GPS metadata as JSON.
# Usage: stripmeta <file> [file ...]
function stripmeta --description 'Strip all metadata from image files with exiftool'
    if not command -sq exiftool
        abort "Error: exiftool is not installed. Install it with 'brew install exiftool' first."
        return 1
    end

    if not command -sq diff
        abort "Error: diff is not installed."
        return 1
    end

    if test (count $argv) -eq 0
        abort "Error: No input file(s) specified."
        return 1
    end

    set -l has_magick 0
    if command -sq magick
        set has_magick 1
    end

    set -l display_tags -Make -Model '-*SerialNumber' '-Camera*' '-Device*' '-Lens*' '-GPS*'

    for file in $argv
        if not test -f "$file"
            abort "Error: '$file' not found."
            continue
        end

        set -l before_metadata (command exiftool -j -a -g1 -s $display_tags -- "$file")
        set -l before_status $status
        if test "$before_status" -ne 0
            abort "Error: Could not read metadata from '$file'."
            return 1
        end

        set -l ext (string lower -- (string split -r -m1 . -- "$file")[2])
        set -l target "$file"

        if test "$ext" != png
            if test "$has_magick" -eq 1
                set -l base (string replace -r '\.[^.]*$' '' -- "$file")
                set target "$base.png"

                section "Converting $file >> $target"
                formatexec "magick '$file' '$target'"
                and rm -f "$file"
            else
                abort "Warning: ImageMagick's 'magick' is not installed; stripping metadata from '$file' in its original format. Install it with 'brew install imagemagick' to convert to PNG first."
            end
        end

        section "Stripping metadata from $target"

        # Keep the ICC color profile so exiftool doesn't warn that colors may be affected.
        if not formatexec "exiftool -all= --icc_profile:all -overwrite_original '$target'"
            abort "Error: Could not strip metadata from '$target'."
            return 1
        end

        set -l after_metadata (command exiftool -j -a -g1 -s $display_tags -- "$target")
        set -l after_status $status
        if test "$after_status" -ne 0
            abort "Error: Could not read metadata from '$target'."
            return 1
        end

        section "Device/GPS metadata diff: $file"
        set -l metadata_diff (command diff -u -L "Before: $file" -L "After: $target" \
            (printf '%s\n' $before_metadata | psub) \
            (printf '%s\n' $after_metadata | psub))
        set -l diff_status $status
        if test "$diff_status" -gt 1
            abort "Error: Could not compare metadata for '$file'."
            return 1
        else if test "$diff_status" -eq 0
            printf '%s\n' "No device or GPS metadata changes."
        else
            for line in $metadata_diff
                switch "$line"
                    case '-*'
                        printf '%s%s%s\n' "$RED" "$line" "$NC"
                    case '+*'
                        printf '%s%s%s\n' "$GREEN" "$line" "$NC"
                    case '@@*'
                        printf '%s%s%s\n' "$CYAN" "$line" "$NC"
                    case '*'
                        printf '%s\n' "$line"
                end
            end
        end

        ok "$PC_PATH$target$PC_RESET is now metadata-free"
    end
end
