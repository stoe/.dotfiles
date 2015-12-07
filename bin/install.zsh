#!/bin/zsh

source "../inc/helpers.zsh"

# DISABLED ---------------------------------------------------------------------
disabled

print -P "installing %F{11}~/%f"

# antigen ----------------------------------------------------------------------
if [ ! -h "$HOME/.antigen" ]; then
    section "antigen" "already installed"
else
    section "antigen"

    formatexec "cd $HOME"
    formatexec "git clone https://github.com/zsh-users/antigen.git .antigen"
fi

ok

# brew -------------------------------------------------------------------------
if type brew | grep "not found" > /dev/null 2>&1 ; then
    section "brew"

    formatexec "ruby -e $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    # tap
    formatexec "brew tap caskroom/cask"
    formatexec "brew tap caskroom/versions"
    formatexec "brew tap homebrew/versions"
else
    section "brew" "already installed"
    print -P "  updating ..."

    formatexec "brew update > /dev/null 2>&1"
    formatexec "brew cask update > /dev/null 2>&1"
fi

# brews
BREWS=(
    brew-cask
    duck
    ffmpeg
    git git-extras git-flow
    imagemagick
    node nvm
    openssl
    p7zip
    python
    rbenv ruby-build
    rename
    tree
    wget
)

for BREW in $BREWS; do
    if brew list | grep -q "$BREW"; then
        formatexec "brew upgrade $BREW > /dev/null 2>&1"
        print -P "upgraded %F{4}$BREW%f %F{2}\u${CODEPOINT_OF_ANONYMICE_UNIF42E}%f"
    else
        formatexec "brew install $BREW > /dev/null 2>&1"
        print -P "installed %F{4}$BREW%f %F{2}\u${CODEPOINT_OF_ANONYMICE_UNIF42E}%f"
    fi
done

# fontforge
if brew list | grep -q "fontforge"; then
    formatexec "brew upgrade fontforge --HEAD > /dev/null 2>&1"
    print -P "upgraded %F{4}fontforge --HEAD%f %F{2}\u${CODEPOINT_OF_ANONYMICE_UNIF42E}%f"
else
    formatexec "brew install fontforge --HEAD > /dev/null 2>&1"
    print -P "installed %F{4}fontforge --HEAD%f %F{2}\u${CODEPOINT_OF_ANONYMICE_UNIF42E}%f"
fi

# casks
CASKS=(
    1password
    adobe-creative-cloud
    alfred
    airserver
    atom
    avast
    bartender
    caffeine
    cheatsheet
    cleanmymac
    cyberduck
    dash
    diffmerge
    divvy
    dropbox
    evernote
    google-drive
    iterm2
    skype
    totalfinder
    totalspaces
    tower
    virtualbox virtualbox-extension-pack
)

for CASK in $CASKS; do
    if brew cask list | grep -q "$CASK"; then
        formatexec "brew cask upgrade $CASK > /dev/null 2>&1"
        print -P "upgraded cask %F{4}$CASK%f %F{2}\u${CODEPOINT_OF_ANONYMICE_UNIF42E}%f"
    else
        formatexec "brew cask install $CASK > /dev/null 2>&1"
        print -P "installed cask %F{4}$CASK%f %F{2}\u${CODEPOINT_OF_ANONYMICE_UNIF42E}%f"
    fi
done

formatexec "brew cleanup"
formatexec "brew cask cleanup"
formatexec "brew prune"

ok

# SYMLINKS ---------------------------------------------------------------------
section "symlinks"

# directories
test -h "$HOME/.atom"           || formatexec "ln -s $HOME/.dotfiles/atom/              $HOME/.atom"
test -h "$HOME/.sencha"         || formatexec "ln -s $HOME/.dotfiles/sencha/            $HOME/.sencha"

# files
test -f "$HOME/editorconfig"    || formatexec "ln -s $HOME/.dotfiles/editorconfig       $HOME/editorconfig"

test -f "$HOME/.gitconfig"      || formatexec "ln -s $HOME/.dotfiles/git/gitconfig      $HOME/.gitconfig"
test -f "$HOME/.gitignore"      || formatexec "ln -s $HOME/.dotfiles/git/gitignore      $HOME/.gitignore"

test -f "$HOME/.eslintrc"       || formatexec "ln -s $HOME/.dotfiles/.eslintrc          $HOME/.eslintrc"
test -f "$HOME/.jshintrc"       || formatexec "ln -s $HOME/.dotfiles/.jshintrc          $HOME/.jshintrc"

test -f "$HOME/.zprofile"       || formatexec "ln -s $HOME/.dotfiles/zsh/zprofile       $HOME/.zprofile"
test -f "$HOME/.zshrc"          || formatexec "ln -s $HOME/.dotfiles/zsh/zshrc          $HOME/.zshrc"
test -f "$HOME/.zshrc_local"    || formatexec "ln -s $HOME/.dotfiles/zsh/zshrc_local    $HOME/.zshrc_local"

ok

# NODE -------------------------------------------------------------------------
section "node"

nvm="${HOME}/.nvm"

[ ! -d "${nvm}" ] && formatexec "mkdir ${nvm}"
[ ! -f $HOME/.npmrc ] && formatexec "touch $HOME/.npmrc"    # npm config file
export NVM_DIR="${nvm}"
source "$(brew --prefix nvm)/nvm.sh"

formatexec "nvm install 0.10"
formatexec "nvm install 0.12"
formatexec "nvm install iojs"
formatexec "nvm alias default 0.12"
formatexec "nvm use default"

ok

# node_modules
section "node_modules" "install || update"

MODS=(
    babel
    babel-eslint
    bower
    cmd-plus
    coffee-script
    dark-mode
    electron-prebuilt
    eslint
    generator-reveal
    grunt-cli
    gulp
    ios-sim
    jscs
    jscs-jsdoc
    mocha
    phonegap
    yo
)

for MOD in $MODS; do
    formatexec "npm update -g $MOD"
done

ok

# DONE & RELOAD ----------------------------------------------------------------
finished
