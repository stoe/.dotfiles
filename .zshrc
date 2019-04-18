export LC_CTYPE=en_AU.UTF-8
export LC_ALL=en_AU.UTF-8

# shortcut to this dotfiles path is $DFH
export DFH=$HOME/private/dotfiles

[ -f "${DFH}/inc/paths.zsh" ] && source "${DFH}/inc/paths.zsh"
[ -f "${DFH}/inc/helpers.zsh" ] && source "${DFH}/inc/helpers.zsh"
[ -f "${DFH}/inc/functions.zsh" ] && source "${DFH}/inc/functions.zsh"
[ -f "${DFH}/inc/aliases.zsh" ] && source "${DFH}/inc/aliases.zsh"

export EDITOR='code'

setopt HIST_IGNORE_ALL_DUPS    # Delete old recorded entry if new entry is a duplicate.
setopt HIST_IGNORE_SPACE       # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS       # Don't write duplicate entries in the history file.

autoload -Uz colors && colors

# Stash your environment variables in ~/.zshrc_local. This means they'll stay out
# of your main dotfiles repository (which may be public, like this one), but
# you'll have access to them in your scripts.
test -f "$HOME/.zshrc_local" && source "$HOME/.zshrc_local"

# initialize autocomplete here, otherwise functions won't be loaded
autoload -U compinit
compinit

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# load zgen
source "${HOME}/.zgen/zgen.zsh"

# if the init scipt doesn't exist
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh

    # plugins
    zgen oh-my-zsh plugins/brew
    zgen oh-my-zsh plugins/colored-man-pages
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/gitignore
    zgen oh-my-zsh plugins/node
    zgen oh-my-zsh plugins/npm
    zgen oh-my-zsh plugins/nvm
    zgen load pbar1/zsh-terraform

    # zgen oh-my-zsh plugins/command-not-found
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load zsh-users/zsh-autosuggestions
    zgen load djui/alias-tips

    # completions

    # theme
    zgen oh-my-zsh themes/af-magic

    # save all to init script
    zgen save
fi

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

# BEGIN ANSIBLE MANAGED BLOCK
# added by https://github.com/stoe/ansible-macos-playbook
unset npm_config_prefix
export NVM_DIR="${HOME}/.nvm"
[ -s "${NVM_DIR}/nvm.sh" ] && . "${NVM_DIR}/nvm.sh" # This loads nvm
[[ -r "${NVM_DIR}/bash_completion" ]] && . "${NVM_DIR}/bash_completion"

autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
# END ANSIBLE MANAGED BLOCK
