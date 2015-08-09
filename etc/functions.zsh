#!/bin/zsh

# open in Finder.app
function o() {
    if [ $# -eq 0 ]; then
        # no arguments opens current directory
       open .
    else
        # otherwise opens the given location
       open "$@"
    fi
}

# open in Tower.app
function gt() {
    if [ $# -eq 0 ]; then
        # no arguments opens current directory
       gittower .
    else
        # otherwise opens the given location
       gittower "$@"
    fi
}

# Create a new directory and enter it
function mkd() {
    mkdir -p "$@" && cd "$@"
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
    tree -aC -I '.git|node_modules|bower_components|.node-gyp|compile-cache' --dirsfirst "$@" | less -FRNX
}

# .mov -> .gif
function mov2gif() {
    local file="${1%.*}"
    local scale="${2:-600}"

    local tmpFolder=".mov2png"

    clear

    echo "${1} >> ${ORANGE}${file}.gif${RESET} (scale: ${scale})"
    echo ""

    mkdir "${tmpFolder}"

    ffmpeg -i "${file}.mov" -vf scale="${scale}":-1 -r 10 "${tmpFolder}"/ffout%3d.png -v 0

    convert -delay 8 -loop 0 $tmpFolder/ffout*.png "${file}-${scale}.gif"

    rm -rf "${tmpFolder}"

    echo "${GREEN}done${RESET}."
    echo ""
}

# screenshot shadows
function hideshadows() {
    local disable=false

    if [[ $1 != '' && $1 == 'true' ]]; then
        print -P "\n%F{red}hiding%f screenshot shadows"
        disable=true
    else
        print -P "\n%F{green}showing%f screenshot shadows"
    fi

    defaults write com.apple.screencapture disable-shadow -bool $disable
    killall SystemUIServer
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
    local tmpFile="${@%/}.tar"
    tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1

    size=$(
       stat -f"%z" "${tmpFile}" 2> /dev/null;   # OS X `stat`
       stat -c"%s" "${tmpFile}" 2> /dev/null    # GNU `stat`
    )

    local cmd=""

    if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
        # the .tar file is smaller than 50 MB and Zopfli is available; use it
        cmd="zopfli"
    else
        if hash pigz 2> /dev/null; then
            cmd="pigz"
        else
            cmd="gzip"
        fi
    fi

    echo "Compressing .tar using \`${cmd}\`..."

    "${cmd}" -v "${tmpFile}" || return 1
    [ -f "${tmpFile}" ] && rm "${tmpFile}"

    echo "${tmpFile}.gz created successfully."
}

# Extract any archive.
function extract () {
    if [ $# -ne 1 ]; then
        echo "Error: No file specified."
        return 1
    fi

    if [ -f "${1}" ] ; then
        case "${1}" in
            *.tar.bz2) tar xvjf "${1}"   ;;
            *.tar.gz)  tar xvzf "${1}"   ;;
            *.bz2)     bunzip2 "${1}"    ;;
            *.rar)     unrar x "${1}"    ;;
            *.gz)      gunzip "${1}"     ;;
            *.tar)     tar xvf "${1}"    ;;
            *.tbz2)    tar xvjf "${1}"   ;;
            *.tgz)     tar xvzf "${1}"   ;;
            *.zip)     unzip "${1}"      ;;
            *.Z)       uncompress "${1}" ;;
            *.7z)      7z x "${1}"       ;;
            *)         echo "'${1}' cannot be extracted via extract" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# cleanup "Open With"
function lsclean() {
    clear

    /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
    killall Finder

    print -P "\n%F{cyan}Open With%s has been rebuilt! %F{green}Finder%f relaunched."
}

# cleanup launchpad
function lpclean() {
    clear

    defaults write com.apple.dock ResetLaunchPad -bool true
    killall Dock

    print -P "\n%F{cyan}Launchpad%f has been rebuilt!"
}
