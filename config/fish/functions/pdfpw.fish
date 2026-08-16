# Password-protected PDF creation using Ghostscript, translated from the
# .pdfpw submodule's pdfpw.zsh (config/.pdfpw/pdfpw.zsh). The submodule
# itself stays zsh-only (separate upstream repo); this is a fish-native
# reimplementation for the interactive fish shell.
#/ DESCRIPTION:
#/   Create password-protected PDF files using Ghostscript with user and owner passwords.
#/   Validates inputs, optionally retrieves owner password from 1Password, and encrypts PDFs.
#/
#/ USAGE:
#/   pdfpw <input.pdf> [output.pdf] [-u|--user-password <pw>] [-o|--owner-password <pw>] [-h|--help]
#/
#/ ARGUMENTS:
#/   input.pdf                 Path to input PDF file (must have .pdf extension)
#/   output.pdf                (Optional) Path to output PDF file (defaults to <input>-protected.pdf)
#/
#/ OPTIONS:
#/   -u, --user-password <pw>  User password for opening the PDF (required)
#/   -o, --owner-password <pw> Owner password for permissions (optional; defaults to 1Password secret)
#/   -h, --help                Show usage information and exit
#/
#/ DEFAULTS:
#/   Output file:    <input>-protected.pdf
#/   Owner password: op://Private/CLIPWD/credential (via 1Password CLI)
#/   Encryption:     128-bit (R3) with printing allowed only (-56)
#/
#/ REQUIREMENTS:
#/   Ghostscript (gs) must be installed and in PATH.
#/   1Password CLI (op) must be installed for default owner password retrieval.
function pdfpw --description 'PDF password protection with Ghostscript + 1Password integration'
    function _pdfpw_usage
        grep '^#/' -- (status current-filename) | cut -c 4-
    end

    if test (count $argv) -eq 1; and contains -- $argv[1] -h --help
        _pdfpw_usage
        return 0
    end

    if test (count $argv) -lt 1
        abort "Expected at least <input.pdf>."
        _pdfpw_usage
        return 1
    end

    if not command -sq gs
        abort "Required tool not found: gs. Please install 'gs' and try again."
        return 1
    end

    set -l inputFile $argv[1]
    set -l outputFile
    set -l userPassword
    set -l ownerPassword
    set -e argv[1]

    if not test -f "$inputFile"
        abort "Input file '$inputFile' does not exist."
        return 1
    end

    if not test -r "$inputFile"
        abort "Input file '$inputFile' is not readable."
        return 1
    end

    switch $inputFile
        case '*.pdf' '*.PDF'
            # ok
        case '*'
            abort "File must have .pdf extension (got: $inputFile)"
            return 1
    end

    if test (count $argv) -gt 0; and not string match -q -- '-*' $argv[1]
        set outputFile $argv[1]
        set -e argv[1]
    end

    if test -z "$outputFile"
        set outputFile (string replace -r '\.[^.]*$' '' -- $inputFile)"-protected.pdf"
    end

    while test (count $argv) -gt 0
        switch $argv[1]
            case -h --help
                _pdfpw_usage
                return 0
            case -u --user-password
                if test (count $argv) -lt 2
                    abort "-u|--user-password requires a password argument."
                    return 1
                end
                set userPassword $argv[2]
                set -e argv[1]
                set -e argv[1]
            case -o --owner-password
                if test (count $argv) -lt 2
                    abort "-o|--owner-password requires a password argument."
                    return 1
                end
                set ownerPassword $argv[2]
                set -e argv[1]
                set -e argv[1]
            case '-*'
                abort "Unknown flag '$argv[1]'."
                return 1
            case '*'
                abort "Too many positional arguments ('$argv[1]')."
                return 1
        end
    end

    if test -z "$userPassword"
        abort "User password is required. Use -u|--user-password to specify."
        return 1
    end

    if test -z "$ownerPassword"
        if not command -sq op
            abort "1Password CLI (op) is not installed. Install it or provide owner password with -o|--owner-password."
            return 1
        end
        set ownerPassword (op read "op://Private/CLIPWD/credential" 2>/dev/null)
        if test -z "$ownerPassword"
            abort "Failed to retrieve owner password from 1Password."
            return 1
        end
    end

    section "Encrypting $inputFile" "128-bit (R3), printing allowed only"
    printf '%sInput:    %s%s\n' "$BLUE" "$inputFile" "$NC"
    printf '%sOutput:   %s%s\n' "$BLUE" "$outputFile" "$NC"

    if not gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite \
        -dEncryptionR=3 \
        -dKeyLength=128 \
        -dPermissions=4 \
        -sUserPassword="$userPassword" \
        -sOwnerPassword="$ownerPassword" \
        -sOutputFile="$outputFile" \
        "$inputFile" 2>/dev/null
        abort "Ghostscript encryption failed."
        return 1
    end

    ok "Encrypted $inputFile → $outputFile (128-bit R3 encryption, printing allowed only)"
end
