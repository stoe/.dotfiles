# shortcut to this dotfiles path is $DFH
export DFH=$HOME/private/dotfiles

autoload -Uz colors && colors

# Stash your environment variables in ~/.zshrc_local. This means they'll stay out
# of your main dotfiles repository (which may be public, like this one), but
# you'll have access to them in your scripts.
test -f "$HOME/.zshrc_local" && source "$HOME/.zshrc_local"

# initialize autocomplete here, otherwise functions won't be loaded
autoload -U compinit
compinit

# https://github.com/pstadler/keybase-gpg-github
if test -f ~/.gnupg/.gpg-agent-info -a -n "$(pgrep gpg-agent)"; then
  source ~/.gnupg/.gpg-agent-info
  export GPG_AGENT_INFO
else
  eval $(gpg-agent --daemon ~/.gnupg/.gpg-agent-info)
fi

# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
# !! moved here as otherwise it didn't work ¯\_(ツ)_/¯
if test gls; then
  alias l="gls -lAh --color"
  alias ll="gls -l --color"
  alias la='gls -A --color'
  alias ls="gls -F --color"
fi
