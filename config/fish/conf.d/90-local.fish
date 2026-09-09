# Local/private overrides. The real file lives outside the repo in
# ~/Documents/.dotfiles/ and is symlinked into $DFH under the same name,
# gitignored via the *.local.fish pattern so its content is never committed.
if test -f "$DFH/.config.personal.local.fish"
    source "$DFH/.config.personal.local.fish"
end
