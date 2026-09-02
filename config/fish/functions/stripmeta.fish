# Remove all metadata (EXIF/IPTC/XMP) from one or more image files, in place.
# Non-PNG files are converted to PNG first (when ImageMagick is available) so
# exiftool never has to drop an ICC profile from a lossy format.
# Usage: stripmeta <file> [file ...]
function stripmeta --description 'Strip all metadata from image files with exiftool'
    if not command -sq exiftool
        abort "Error: exiftool is not installed. Install it with 'brew install exiftool' first."
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

    for file in $argv
        if not test -f "$file"
            abort "Error: '$file' not found."
            continue
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
        formatexec "exiftool -all= --icc_profile:all -overwrite_original '$target'"

        ok "$PC_PATH$target$PC_RESET is now metadata-free"
    end
end
