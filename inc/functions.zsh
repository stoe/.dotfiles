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

# open in Visual Studio Code.app
function c() {
  if [ $# -eq 0 ]; then
    # no arguments opens current directory
    code .
  else
    # otherwise opens the given location
    code "$@"
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

# open in Tower.app
function gt() {
  if ! $(which gittower &>/dev/null); then
    abort "Please install Tower.app first"
  else
    if [ $# -eq 0 ]; then
      # no arguments opens current directory
      gittower .
    else
      # otherwise opens the given location
      gittower "$@"
    fi
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

### Functions for setting and getting environment variables from the OSX keychain ###
### Adapted from https://www.netmeister.org/blog/keychain-passwords.html ###

### from https://gist.github.com/bmhatfield/f613c10e360b4f27033761bbee4404fd ###

# Use: keychain-environment-variable SECRET_ENV_VAR
function keychain-environment-variable () {
  security find-generic-password -w -a ${USER} -D "environment variable" -s "${1}"
}

# Use: set-keychain-environment-variable SECRET_ENV_VAR
#   provide: super_secret_key_abc123
function set-keychain-environment-variable () {
  [ -n "$1" ] || print "Missing environment variable name"

  # Note: if using bash, use `-p` to indicate a prompt string, rather than the leading `?`
  read -s "?Enter Value for ${1}: " secret

  ( [ -n "$1" ] && [ -n "$secret" ] ) || return 1
  security add-generic-password -U -a ${USER} -D "environment variable" -s "${1}" -w "${secret}"
}

function dstop() {
  question "Do you really want to stop all 🐳  docker containers?" "yn"
  read -rs -k 1 ask
  print -P "%F{8}> $ask%f"

  dockerps=`docker ps -a -q`

  if [ "$ask" = "y" ] && [ "${dockerps}" != "" ]; then
    docker stop `docker ps -a -q`
  else
    abort "no docker containers to stop"
  fi
}

function dclean() {
  question "Do you really want to delete all stopped 🐳  docker containers?" "yn"
  read -rs -k 1 ask
  print -P "%F{8}> $ask%f"

  if [ "$ask" = "y" ]; then
    docker container prune --filter 'label=name!=splunk' --force
  else
    abort "no docker containers to clean"
  fi

  unset $ask;

  question "Do you really want to delete all untagged 🐳  docker images?" "yn"
  read -rs -k 1 ask
  print -P "%F{8}> $ask%f"

  if [ "$ask" = "y" ]; then
    docker image prune --force
  else
    abort "no docker images to clean"
  fi

  unset $ask;
}

# see https://gist.github.com/fvdm/1715d580a22503ce115c#file-homebrew_update-sh
# thanks https://github.com/fvdm
function brewup() {
  local _brew=$(which brew)

  formatexec "$_brew update"

  section "Fetching packages list"

  local _brewsy=`$_brew outdated | wc -l | awk '{print $1}'`

  if [ "$_brewsy" != 0 ]; then
    print -P "%F{3}Outdated packages:%f" "$_brewsy"
    echo
    formatexec "$_brew outdated"

    if [ "$1" != "-y" ]; then
      question "Update these packages?" "yn"
      read -rs -k 1 ask
      print -P "%F{8}> $ask%f"
    fi

    if [ "$ask" = "y" ]; then
      formatexec "$_brew upgrade"
    else
      ok "OK, not doing anything"
    fi
  else
    ok "Nothing to do"
  fi

  section "Doctor & Cleanup"
  formatexec "$_brew doctor"
  echo
  formatexec "$_brew cleanup"

  echo
  ok "DONE"
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
  local tmpFile="${@%/}.tar"

  formatexec "tar -cvf ${tmpFile} --exclude=.DS_Store --exclude=node_modules ${@} || return 1"

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
