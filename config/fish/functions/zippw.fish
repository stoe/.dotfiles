# Password-protected ZIP archive creation using 7-Zip, translated from the
# .zippw submodule's zippw.zsh (config/.zippw/zippw.zsh). The submodule
# itself stays zsh-only (separate upstream repo); this is a fish-native
# reimplementation for the interactive fish shell.
#/ DESCRIPTION:
#/   Create a password-protected ZIP archive using 7-Zip.
#/   Validates inputs and dependencies, then writes a .zip file with encryption.
#/
#/ USAGE:
#/   zippw <input-path> [password] [output.zip]
#/
#/ ARGUMENTS:
#/   input-path    File or directory to archive
#/   password      (Optional) ZIP password; defaults to 1Password secret when omitted
#/   output.zip    (Optional) Output path. Defaults to <input-path>.zip
#/
#/ OPTIONS:
#/   -h, --help    Show usage information and exit
#/
#/ REQUIREMENTS:
#/   7-Zip (7zz) must be installed and available in PATH.
#/   1Password CLI (op) is required only when password is omitted.
function zippw --description 'Password-protected zip archives via 7z'
    function _zippw_usage
        grep '^#/' -- (status current-filename) | cut -c 4-
    end

    function _zippw_default_password
        if not command -sq op
            abort "Required tool not found: op"
            return 1
        end

        set -l defaultPassword (op read "op://Private/CLIPWD/credential" 2>/dev/null)

        if test -z "$defaultPassword"
            abort "Failed to retrieve default password from 1Password (op://Private/CLIPWD/credential)."
            return 1
        end

        printf '%s' "$defaultPassword"
    end

    if test (count $argv) -eq 1; and contains -- $argv[1] -h --help
        _zippw_usage
        return 0
    end

    if test (count $argv) -lt 1; or test (count $argv) -gt 3
        abort "Expected zippw <input-path> [password] [output.zip]"
        _zippw_usage
        return 1
    end

    if not command -sq 7zz
        abort "Required tool not found: 7zz"
        return 1
    end

    set -l inputPath $argv[1]
    set -l password
    set -l outputZip

    if test (count $argv) -ge 2
        if string match -q -- '*.zip' $argv[2]
            set outputZip $argv[2]
        else
            set password $argv[2]
        end
    end

    if test (count $argv) -eq 3
        set outputZip $argv[3]
    end

    if test -z "$outputZip"
        set outputZip (string trim --right --chars=/ -- $inputPath)".zip"
    end

    if not test -e "$inputPath"
        abort "Input path '$inputPath' does not exist."
        return 1
    end

    if test -z "$password"
        set password (_zippw_default_password)
        or return 1
    end

    section "Compressing $inputPath ..."

    7zz a -tzip "-p$password" "$outputZip" "$inputPath"; or return 1

    ok "$outputZip created successfully."
end
