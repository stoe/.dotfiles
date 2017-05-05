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
  local file="$1"
  local filename=$(basename "$file")
  local extension="${filename##*.}"
  local filename="${filename%.*}"
  local scale="${2:-600}"

  local tmpFolder=".mov2png"

  clear

  section "${file} >> ${ORANGE}${filename}.gif${RESET} (scale: ${scale})"

  mkdir "${tmpFolder}"

  formatexec "ffmpeg -i ${file} -vf scale=${scale}:-1 -r 10 ${tmpFolder}/ffout%3d.png -v 0"

  formatexec "convert -delay 8 -loop 0 $tmpFolder/ffout*.png ${filename}-${scale}.gif"

  rm -rf "${tmpFolder}"

  ok
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

  formatexec "defaults write com.apple.screencapture disable-shadow -bool $disable"
  formatexec "killall SystemUIServer"
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
  local tmpFile="${@%/}.tar"

  formatexec "tar -cvf ${tmpFile} --exclude=.DS_Store ${@} || return 1"

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

  section "Compressing .tar using ${cmd}"

  formatexec "${cmd} -v ${tmpFile} || return 1"
  [ -f "${tmpFile}" ] && rm "${tmpFile}"

  ok "${tmpFile}.gz created successfully."
}

# Extract any archive.
function extract () {
  if [ $# -ne 1 ]; then
    abort "Error: No file specified."
    return 1
  fi

  if [ -f "${1}" ] ; then
    case "${1}" in
      *.tar.bz2) formatexec "pv ${1} | tar xjf -" ;;
      *.tar.gz)  formatexec "pv ${1} | tar xzf -" ;;
      *.bz2)     formatexec "bunzip2 ${1}"        ;;
      *.rar)     formatexec "unrar x ${1}"        ;;
      *.gz)      formatexec "gunzip ${1}"         ;;
      *.tar)     formatexec "pv ${1} | tar xf -"  ;;
      *.tbz2)    formatexec "pv ${1} | tar xjf -" ;;
      *.tgz)     formatexec "pv ${1} | tar xzf -" ;;
      *.zip)     formatexec "7z x ${1}" ;; # http://stackoverflow.com/questions/32253631/mac-terminal-unzip-zip64
      *.Z)       formatexec "uncompress ${1}"     ;;
      *.7z)      formatexec "7z x ${1}"           ;;
      *)         abort "'${1}' cannot be extracted via extract" ;;
    esac
  else
    abort "'$1' is not a valid file"
  fi
}

# cleanup "Open With"
function lsclean() {
  "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister" -kill -r -domain local -domain system -domain user; killall Finder

  ok "%F{4}Open With%s has been rebuilt! %F{2}Finder%f relaunched."
}

# cleanup launchpad
function lpclean() {
  # http://nickmanderfield.com/2014/08/ultimate-guide-to-fixing-and-resetting-osx-yosemite-launchpad/
  defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock;

  ok "%F{4}Launchpad%f has been rebuilt!"
}

# speedtest (https://github.com/sivel/speedtest-cli)
function speedtest() {
  local _cmd="${1:-f}"

  if [ ${_cmd} == 's' ]; then
    if ! $(npm -g ls | grep "speed-test@[0-9\.]*$" > /dev/null 2>&1); then
      # install if not not globally available
      formatexec "npm install -g speed-test > /dev/null 2>&1"
    fi

    formatexec "speed-test --verbose --bytes"
  else
    if ! $(npm -g ls | grep "fast-cli@[0-9\.]*$" > /dev/null 2>&1); then
      # install if not not globally available
      formatexec "npm install -g fast-cli > /dev/null 2>&1"
    fi

    formatexec "fast"
  fi

  echo
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

# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/osx/osx.plugin.zsh#L110
function pfd() {
  osascript 2>/dev/null <<EOF
    tell application "Finder"
      return POSIX path of (target of window 1 as alias)
    end tell
EOF
}

# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/osx/osx.plugin.zsh#L131
function cdf() {
  cd "$(pfd)"
}

# delete those temp (.DS_Store, MS Word) files in style
function cleanup() {
  section "macOS"
  find . -type f -name '*.DS_Store' -ls -delete

  section "MS Office"
  find . -type f -name '\~\$*.*' -ls -delete
}
