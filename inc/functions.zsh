# open in Visual Studio Code.app
function c() {
  if ! $(which code &>/dev/null); then
    abort "Please install Visual Studio Code.app first"
  else
    if [ $# -eq 0 ]; then
      # no arguments opens current directory
      code .
    else
      # otherwise opens the given location
      code "$@"
    fi
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
  print -P "%39F> $ask%f"

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
  print -P "%39F> $ask%f"

  if [ "$ask" = "y" ]; then
    docker container prune --filter 'label=name!=splunk' --force
  else
    abort "no docker containers to clean"
  fi

  unset $ask;

  question "Do you really want to delete all untagged 🐳  docker images?" "yn"
  read -rs -k 1 ask
  print -P "%39F> $ask%f"

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
  formatexec "brew update"

  section "Fetching cask list"
  print -P "%244F> brew outdated --cask%f"

  local _casks=$(brew outdated --cask | wc -l | awk '{print $1}')

  if [ "$_casks" != 0 ]; then
    print -P "%5FOutdated casks:%f" "$_casks"
    brew outdated --cask --verbose | grep -v '(latest)' | awk '{print $1}'

    if [ "$1" != "-y" ]; then
      question "Update these casks?" "yn"
      read -rs -k 1 ask
      print -P "%39F> $ask%f"
    fi

    if [ "$ask" = "y" ]; then
      brew outdated --cask --verbose | grep -v '(latest)' | awk '{print $1}' | xargs brew upgrade --cask
    else
      ok "OK, not doing anything"
    fi
  else
    ok "Nothing to do"
  fi

  section "Fetching mas list"
  print -P "%244F> mas outdated%f"

  local _apps=`mas outdated | wc -l | awk '{print $1}'`

  if [ "$_apps" != 0 ]; then
    print -P "%5FOutdated casks:%f" "$_apps"
    mas outdated

    if [ "$1" != "-y" ]; then
      question "Update these apps?" "yn"
      read -rs -k 1 ask
      print -P "%39F> $ask%f"
    fi

    if [ "$ask" = "y" ]; then
      mas upgrade
    else
      ok "OK, not doing anything"
    fi
  else
    ok "Nothing to do"
  fi

  section "Fetching packages list"
  print -P "%244F> brew outdated --formula%f"

  local _brews=`brew outdated --formula | wc -l | awk '{print $1}'`

  if [ "$_brews" != 0 ]; then
    print -P "%5FOutdated packages:%f" "$_brews"
    brew outdated --formula --verbose | grep -v '(latest)' | awk '{print $1}'

    if [ "$1" != "-y" ]; then
      question "Update these packages?" "yn"
      read -rs -k 1 ask
      print -P "%39F> $ask%f"
    fi

    if [ "$ask" = "y" ]; then
      brew outdated --formula --verbose | grep -v '(latest)' | awk '{print $1}' | xargs brew upgrade --formula
    else
      ok "OK, not doing anything"
    fi
  else
    ok "Nothing to do"
  fi

  section "Cleanup"
  formatexec "brew cleanup"

  section "Doctor"
  formatexec "brew doctor"

  ok "DONE"
}

# Create a .tgz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
  section "Compressing ${@} ..."

  local size=$(du -ck ${@} | tail -n 1 | awk '{print $1}')
  local cmd=""
  local progress=""

  if (( size < 51200 )) && hash zopfli 2> /dev/null; then
    # the content is less than 50 MB and zopfli is available; use it
    cmd="zopfli"
  else
    if hash pigz 2> /dev/null; then
      # pigz is available; use it
      cmd="pigz"
    else
      cmd="gzip"
    fi
  fi

  if (( size > 524288 )); then
    # the content is greater than 0.5GB; show a progress bar
    progress="pv -s $((${size} * 1024)) | "
  fi

  formatexec "tar -c --exclude='node_modules' --exclude='.git' --exclude='.github' --exclude='.env' --exclude='.DS_Store' -f - ${@} | ${progress}${cmd} > ${@}.tar.gz || return 1"

  ok "${@}.tar.gz created successfully."
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

# .mov -> .gif
function mov2gif() {
    local file="${1%.*}"
    local scale="${2:-600}"
    local tmpFolder=".mov2png"

    section "${1} >> ${file}.gif (scale: ${scale})"

    rm -rf "${tmpFolder}" &>/dev/null
    mkdir "${tmpFolder}" &>/dev/null

    formatexec "ffmpeg -i ${file}.mov -vf scale=\"${scale}\":-1 -r 10 ${tmpFolder}/ffout%3d.png -v 0"
    formatexec "convert -delay 8 -loop 0 $tmpFolder/ffout*.png ${file}-${scale}.gif"

    rm -rf "${tmpFolder}" &>/dev/null

    ok "$(pwd)/%178F${file}.gif%f saved"
}
