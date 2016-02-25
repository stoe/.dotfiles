#!/bin/zsh

source "../inc/helpers.zsh"

# DISABLED ---------------------------------------------------------------------
disabled

DO_CASKS="${1:0}"
DO_NPM="${2:0}"

if [ "${1}" = 'npm' ]; then
    DO_CASKS='false'
    DO_NPM="npm"
fi

print -P "installing %F{11}~/%f"		 print -P "installing %F{11}~/%f"


# ANTIGEN ----------------------------------------------------------------------
if [ ! -h "$HOME/.antigen" ]; then
    section "antigen" "already installed"
else
    section "antigen"

    formatexec "cd $HOME"
    formatexec "git clone https://github.com/zsh-users/antigen.git .antigen"
fi

ok

# BREW -------------------------------------------------------------------------
if type brew | grep "not found" > /dev/null 2>&1 ; then
    section "brew"

    print -P "  installing..."

    formatexec "ruby -e $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    # taps
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
print -P ""
print -P "{ %F{11}brews%f }"

BREWS=(
    brew-cask
    duck
    ffmpeg
    git git-extras git-lfs
    imagemagick
    node nvm
    openssl
    p7zip
    python
    rename
    tree
    wget
)

# git-flow rbenv ruby-build

for BREW in $BREWS; do
    if brew list | grep -q "$BREW"; then
        formatexec "brew upgrade $BREW > /dev/null 2>&1"
        print -P "upgraded %F{4}$BREW%f %F{2}✓%f"
    else
        formatexec "brew install $BREW > /dev/null 2>&1"
        print -P "installed %F{4}$BREW%f %F{2}✓%f"
    fi
done

# fontforge
if brew list | grep -q "fontforge"; then
    formatexec "brew upgrade fontforge --HEAD > /dev/null 2>&1"
    print -P "upgraded %F{4}fontforge --HEAD%f %F{2}✓%f"
else
    formatexec "brew install fontforge --HEAD > /dev/null 2>&1"
    print -P "installed %F{4}fontforge --HEAD%f %F{2}✓%f"
fi

# casks
print -P ""
print -P "{ %F{11}casks%f }"

if [ "${DO_CASKS}" = 'casks' ]; then
    CASKS=(
        1password
        adobe-creative-cloud
        alfred
        airserver
        atom
        avast
        bartender
        cheatsheet
        cleanmymac
        commander-one
        dash
        diffmerge
        divvy
        dropbox
        evernote
        google-drive
        iterm2
        keepingyouawake
        skype
        tower
        virtualbox virtualbox-extension-pack
    )

        # *** old casks
        # caffeine cyberduck totalfinder totalspaces

    for CASK in $CASKS; do
        if brew cask list | grep -q "$CASK"; then
            formatexec "brew cask upgrade $CASK > /dev/null 2>&1"
            print -P "upgraded cask %F{4}$CASK%f %F{2}\u${CODEPOINT_OF_ANONYMICE_UNIF42E}%f"
        else
            formatexec "brew cask install $CASK > /dev/null 2>&1"
            print -P "installed cask %F{4}$CASK%f %F{2}\u${CODEPOINT_OF_ANONYMICE_UNIF42E}%f"
        fi
    done
else
    print -P "%F{8}... skipping%f"
    print -P ""
fi

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
test -f "$HOME/editorconfig"    || formatexec "ln -s $HOME/.dotfiles/.editorconfig      $HOME/editorconfig"

test -f "$HOME/.gitconfig"      || formatexec "ln -s $HOME/.dotfiles/git/gitconfig      $HOME/.gitconfig"
test -f "$HOME/.gitignore"      || formatexec "ln -s $HOME/.dotfiles/git/gitignore      $HOME/.gitignore"

test -f "$HOME/.eslintrc"       || formatexec "ln -s $HOME/.dotfiles/.eslintrc          $HOME/.eslintrc"
test -f "$HOME/.jshintrc"       || formatexec "ln -s $HOME/.dotfiles/.jshintrc          $HOME/.jshintrc"

# test -f "$HOME/.slate"          || formatexec "ln -s $HOME/.dotfiles/.slate             $HOME/.slate"

test -f "$HOME/.zlogin"         || formatexec "ln -s $HOME/.dotfiles/zsh/zlogin         $HOME/.zlogin"
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

print -P "{ %F{11}node version%f }"
formatexec "nvm install iojs"       # install latest io.js version
formatexec "nvm install node"       # install latest node.js version
formatexec "nvm alias default node"
formatexec "nvm use default"

ok

# node_modules
print -P ""
print -P "{ %F{11}node_modules%f install || update }"

if [ "${DO_NPM}" = 'npm' ]; then

    MODS=(
        cordova phonegap ios-sim
        eslint babel babel-cli babel-eslint
        jscs jscs-jsdoc
        bower yo
        grunt-cli gulp
        mocha jasmine
        coffee-script
        cmd-plus
        dark-mode
        electron-prebuilt
        tldr
        doctoc
    )

    for MOD in $MODS; do
        if $(npm -g ls | grep "$MOD@[0-9\.]*$" > /dev/null 2>&1); then
            formatexec "npm upgrade -g $MOD"
            print -P "upgraded %F{4}$MOD%f %F{2}\u${CODEPOINT_OF_ANONYMICE_UNIF42E}%f"
        else
            formatexec "npm install -g $MOD > /dev/null 2>&1"
            print -P "installed %F{4}$MOD%f %F{2}\u${CODEPOINT_OF_ANONYMICE_UNIF42E}%f"
        fi
    done
else
    print -P "%F{8}... skipping%f"
    print -P ""
fi

formatexec "npm ls -g | grep "^[└├]" | sed "s/─┬/──/g""

ok

# DONE & RELOAD ----------------------------------------------------------------
finished
