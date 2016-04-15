# open in Atom.app
function a() {
    if [ $# -eq 0 ]; then
        # no arguments opens current directory
        atom .
    else
        # otherwise opens the given location
        atom "$@"
    fi
}


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
        print -P "\n%F{1}hiding%f screenshot shadows"
        disable=true
    else
        print -P "\n%F{2}showing%f screenshot shadows"
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

    "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister" -kill -r -domain local -domain system -domain user; killall Finder

    print -P "\n%F{4}Open With%s has been rebuilt! %F{2}Finder%f relaunched."
}

# cleanup launchpad
function lpclean() {
    clear

    # http://nickmanderfield.com/2014/08/ultimate-guide-to-fixing-and-resetting-osx-yosemite-launchpad/
    defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock;

    print -P "\n%F{4}Launchpad%f has been rebuilt!"
}

# speedtest (https://github.com/sivel/speedtest-cli)
function speedtest() {
    clear

    if brew list | grep -q speedtest_cli; then
        print -P "\n  %F{8}> speedtest_cli --simple%f"
        print -P "  via %F{4}https://github.com/sivel/speedtest-cli%f\n"

        speedtest_cli --simple
    else
        print -P "\n  %F{1}✗%f %F{8}speedtest_cli%f not found"
        print -P "  install via %F{8}> brew install speedtest_cli%f"

        print -P "\n  %F{8}> wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test10.zip%f\n"

        wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test10.zip
    fi

    print -P "\n  %F{2}✔%f done"
}

# show available color list
function colorlist() {
    # see https://github.com/sykora/etc/blob/master/zsh/functions/spectrum/

    local SUPPORT

    # Optionally handle impoverished terminals.
    if (( $# == 0 )); then
        SUPPORT=256
    else
        SUPPORT=$1
    fi

    for COLOR in {000..$SUPPORT}; do
        # http://www.pirateipsum.me/
        print -P "  [ $COLOR ] %F{$COLOR}Walking the plank, arg!%f"
    done
}
