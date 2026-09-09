# Configure PatrickF1/fzf.fish keybindings (Fisher plugin installed via
# fish_plugins). Default bindings: \cr history, \ct file search, \cg\cg git
# log, \cg\cs git status, \ct\ca variables, \cg\cf directory search.
if status is-interactive; and functions -q fzf_configure_bindings
    fzf_configure_bindings
end
