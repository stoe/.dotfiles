# Homebrew shellenv (replaces .zprofile's ARM-only `eval "$(/opt/homebrew/bin/brew shellenv)"`)
if command -sq brew
    eval (brew shellenv fish)
else if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv fish)
end
