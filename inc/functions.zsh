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

# open in Visual Studio Code Insiders.app
function ci() {
  if ! $(which code-insiders &>/dev/null); then
    abort "Please install Visual Studio Code Insiders.app first"
  else
    if [ $# -eq 0 ]; then
      # no arguments opens current directory
      code-insiders .
    else
      # otherwise opens the given location
      code-insiders "$@"
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
  if ! hash gittower &>/dev/null; then
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

# Usage: keychain-environment-variable SECRET_ENV_VAR
function keychain-environment-variable () {
  security find-generic-password -w -a ${USER} -D "environment variable" -s "${1}"
}

# Usage: set-keychain-environment-variable SECRET_ENV_VAR
#   provide: super_secret_key_abc123
function set-keychain-environment-variable () {
  # exit if no argument is provided
  [ -n "$1" ] || return 1

  # Note: if using bash, use `-p` to indicate a prompt string, rather than the leading `?`
  read -s "?Enter Value for ${1}: " secret

  ( [ -n "$1" ] && [ -n "$secret" ] ) || return 1
  security add-generic-password -U -a ${USER} -D "environment variable" -s "${1}" -w "${secret}"
}

function dstop() {
  question "Do you really want to stop all 🐳  docker containers?" "yn"
  read -rs -k 1 ask
  print -P "${PC_ANSWER}> $ask${PC_RESET}"

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
  print -P "${PC_ANSWER}> $ask${PC_RESET}"

  if [ "$ask" = "y" ]; then
    docker container prune --filter 'label=name!=splunk' --force
  else
    abort "no docker containers to clean"
  fi

  unset $ask;

  question "Do you really want to delete all untagged 🐳  docker images?" "yn"
  read -rs -k 1 ask
  print -P "${PC_ANSWER}> $ask${PC_RESET}"

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
  # Only allow -y flag or no arguments
  if [ -n "$1" ] && [ "$1" != "-y" ]; then
    abort "Error: Only -y flag is supported."
    return 1
  fi

  section "Homebrew 🍺"
  formatexec "brew --version"

  section "Updating Homebrew"
  formatexec "brew update"

  section "Casks"
  print -P "${PC_CMD}> brew outdated --cask${PC_RESET}"

  local _cask_list
  _cask_list=$(brew outdated --cask --greedy-latest --verbose | awk '{print $1}')

  if [[ -n "$_cask_list" ]]; then
    print -P "${PC_NOTICE}Outdated casks:${PC_RESET}"
    echo "$_cask_list"

    if [ "$1" != "-y" ]; then
      question "Update these casks?" "yn"
      read -rs -k 1 ask
      print -P "${PC_ANSWER}> $ask${PC_RESET}"
    else
      ask="y"
    fi

    if [ "$ask" = "y" ]; then
      echo "$_cask_list" | xargs brew upgrade --cask --greedy-latest
    else
      ok "OK, not doing anything"
    fi
  else
    ok "Nothing to do"
  fi

  section "Mac App Store"
  print -P "${PC_CMD}> mas outdated${PC_RESET}"

  # Mac App Store apps to skip during upgrade (id per `mas outdated`)
  local -a _mas_ignore=(
    1596916655  # Push Security
  )

  local _app_list
  _app_list=$(mas outdated)
  local _id
  for _id in "${_mas_ignore[@]}"; do
    _app_list=$(echo "$_app_list" | grep -v "^${_id}[[:space:]]")
  done

  if [[ -n "$_app_list" ]]; then
    print -P "${PC_NOTICE}Outdated apps:${PC_RESET}"
    echo "$_app_list"

    if [ "$1" != "-y" ]; then
      question "Update these apps?" "yn"
      read -rs -k 1 ask
      print -P "${PC_ANSWER}> $ask${PC_RESET}"
    else
      ask="y"
    fi

    if [ "$ask" = "y" ]; then
      echo "$_app_list" | awk '{print $1}' | xargs mas upgrade
    else
      ok "OK, not doing anything"
    fi
  else
    ok "Nothing to do"
  fi

  section "Formulae"
  print -P "${PC_CMD}> brew outdated --formula${PC_RESET}"

  local _brew_list
  _brew_list=$(brew outdated --formula --verbose | awk '{print $1}')

  if [[ -n "$_brew_list" ]]; then
    print -P "${PC_NOTICE}Outdated packages:${PC_RESET}"
    echo "$_brew_list"

    if [ "$1" != "-y" ]; then
      question "Update these packages?" "yn"
      read -rs -k 1 ask
      print -P "${PC_ANSWER}> $ask${PC_RESET}"
    else
      ask="y"
    fi

    if [ "$ask" = "y" ]; then
      echo "$_brew_list" | xargs brew upgrade --formula
    else
      ok "OK, not doing anything"
    fi
  else
    ok "Everything is up to date"
  fi

  section "Running brew cleanup and doctor"
  formatexec "brew cleanup"
  formatexec "brew doctor"

  ok "DONE 🍻"
}

# see https://docs.npmjs.com/cli/commands/npm-outdated
# see https://docs.npmjs.com/cli/commands/npm-update
# see https://docs.npmjs.com/cli/commands/npm-doctor
function npmup() {
  # Only allow -y flag or no arguments
  if [ -n "$1" ] && [ "$1" != "-y" ]; then
    abort "Error: Only -y flag is supported."
    return 1
  fi

  section "Updating NPM global packages"
  print -P "${PC_CMD}> npm outdated --global${PC_RESET}"

  local packages=`npm outdated --global --depth=0 | grep global | wc -l | awk '{print $1}'`

  if [ "$packages" != 0 ]; then
    print -P "${PC_NOTICE}Outdated packages:${PC_RESET}" "$packages"
    npm outdated --global --depth=0

    if [ "$1" != "-y" ]; then
      question "Update these packages?" "yn"
      read -rs -k 1 ask
      print -P "${PC_ANSWER}> $ask${PC_RESET}"
    else
      ask="y"
    fi

    if [ "$ask" = "y" ]; then
      formatexec "npm update --global --omit=dev --omit=optional --omit=peer --depth=0 --install-strategy=shallow"
    else
      ok "OK, not doing anything"
    fi
  else
    ok "Everything is up to date"
  fi

  if type fnm &>/dev/null; then
    typeset fnm_current_version fnm_node_bin
    fnm_current_version="$(fnm current 2>/dev/null)"

    if [[ -n "$fnm_current_version" && "$fnm_current_version" != "system" && "$fnm_current_version" != "none" ]]; then
      fnm_node_bin="${FNM_DIR:-$HOME/.local/share/fnm}/node-versions/${fnm_current_version}/installation/bin"

      if [[ -d "$fnm_node_bin" ]]; then
        path=("$fnm_node_bin" $path)
      fi
    fi
  fi

  formatexec "npm doctor ping registry environment cache"

  ok "Node\t$(node --version)"
  ok "NPM\tv$(npm --version)"

  ok "DONE"
}

function ghup() {
  section "Updating GitHub CLI extensions"
  formatexec "gh extension upgrade --all"

  section "Updating GitHub Copilot CLI"
  formatexec "copilot update"

  section "Updating GitHub Copilot app"
  formatexec "brew upgrade --greedy --cask github-copilot-app --yes"

  ok "DONE"
}

# Create a .tgz archive, using `zopfli`, `pigz` or `gzip` for compression
# Usage: targz <path>
function targz() {
  section "Compressing ${@} ..."

  local tmp="${@%/}.tar"
  local size=$(du -ck "${@}" | tail -n 1 | awk '{print $1}')
  local cmd=""

  formatexec "tar -cf '${tmp}' --exclude='node_modules' --exclude='.git' --exclude='.github' --exclude='.env' --exclude='.DS_Store' '${@}' || return 1"

  if hash 7zz 2> /dev/null; then
    # 7zz is available; use it
    formatexec "7zz a -tgzip '${tmp}.gz' '${tmp}' || return 1"
  else
    if hash pigz 2> /dev/null; then
      # pigz is available; use it
      cmd="pigz "
    else
      cmd="gzip "
    fi

    formatexec "${cmd}'${tmp}' || return 1"
  fi

  [ -f "${tmp}" ] && /bin/rm -rf "${tmp}" &>/dev/null

  ok "${@}.tar.gz created successfully."
}

# Extract any archive.
# Usage: extract <file>
function extract () {
  if [ $# -ne 1 ]; then
    abort "Error: No file specified."
    return 1
  fi

  if [ -f "${1}" ] ; then
    case "${1}" in
      *.tar.bz2) formatexec "pv '${1}' | tar xjf -" ;;
      *.tar.gz)  formatexec "pv '${1}' | tar xzf -" ;;
      *.bz2)     formatexec "bunzip2 '${1}'"        ;;
      *.rar)     formatexec "unrar x '${1}'"        ;;
      *.gz)      formatexec "gunzip '${1}'"         ;;
      *.tar)     formatexec "pv '${1}' | tar xf -"  ;;
      *.tbz2)    formatexec "pv '${1}' | tar xjf -" ;;
      *.tgz)     formatexec "pv '${1}' | tar xzf -" ;;
      # *.zip)     formatexec "7z x ${1}" ;; # http://stackoverflow.com/questions/32253631/mac-terminal-unzip-zip64
      *.zip)     formatexec "unzip '${1}'"          ;;
      *.Z)       formatexec "uncompress '${1}'"     ;;
      # *.7z)      formatexec "7z x ${1}"           ;;
      *)         abort "'${1}' cannot be extracted via extract" ;;
    esac
  else
    abort "'$1' is not a valid file"
  fi
}

# .mov -> .gif
# Usage: mov2gif <file> <scale>
function mov2gif() {
  local file="${1%.*}"
  local scale="${2:-600}"
  local tmpFolder=".mov2png"

  section "${1} >> ${file}.gif (scale: ${scale})"

  rm -rf "${tmpFolder}" &>/dev/null
  mkdir "${tmpFolder}" &>/dev/null

  formatexec "ffmpeg -i '${file}.mov' -vf scale=\"${scale}\":-1 -r 10 '${tmpFolder}/ffout%3d.png' -v 0"
  formatexec "magick -delay 8 -loop 0 '${tmpFolder}/ffout*.png' '${file}-${scale}.gif'"

  [ -d "${tmpFolder}" ] && /bin/rm -rf "${tmpFolder}" &>/dev/null

  ok "$(pwd)/${PC_PATH}${file}.gif${PC_RESET} saved"
}

# .pdf -> .png
function pdf2png() {
  local file="${1%.*}"
  local outputFolder="${HOME}/Desktop/${file}"

  section "${1} >> ${outputFolder}/*.png"

  # Check if Ghostscript is installed
  if ! hash gs &>/dev/null; then
    abort "Error: Ghostscript is not installed. Install it with 'brew install ghostscript' first."
    return 1
  fi

  rm -rf "${outputFolder}" &>/dev/null
  mkdir "${outputFolder}" &>/dev/null

  # Use proper format sequence for ImageMagick with PDF
  formatexec "magick -density 300 -colorspace sRGB '$(pwd)/${1}' -alpha ${2:-off} '${outputFolder}/${file}.Page %d.png'"

  ok "PNGs saved to ${PC_PATH}${outputFolder}${PC_RESET}"
}

# .docx -> .md
# Usage: docx2md <input-file.docx> [output-name]
function docx2md() {
  # check if pandoc is installed via brew
  if ! hash pandoc 2> /dev/null; then
    abort "Error: pandoc is not installed."
    return 1
  fi

  if [ $# -eq 0 ]; then
    abort "Error: No input file specified."
    return 1
  fi

  local inputFile="${1}"
  local outputName=""

  # If output name is provided, use it, otherwise use input file name without extension
  if [ -n "${2}" ]; then
    # Remove any extension from the output name if present
    outputName="${2%.*}"
  else
    outputName="${inputFile%.*}"
  fi

  local outputFile="${outputName}.md"

  section "${1} >> ${outputFile}"

  formatexec "pandoc -t gfm -s '${inputFile}' -o '${outputFile}'"

  ok "Markdown saved to ${PC_PATH}${outputFile}${PC_RESET}"
}

# https://docs.gitignore.io/install/command-line
function gi() {
  curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/$@
}

# List gh-stack branches with needsRebase status using shared helper colors.
function ghstackview() {
  if ! command -v gh >/dev/null 2>&1; then
    abort "Error: gh is not installed."
    return 127
  fi

  if ! command -v jq >/dev/null 2>&1; then
    abort "Error: jq is not installed."
    return 127
  fi

  # Shared color variables from inc/common.zsh.
  local color_current="$BLUE"
  local color_open="$GREEN"
  local color_true="$RED"
  local color_false="$GRAY"
  local color_reset="$NC"

  local rows
  rows="$(gh stack view --json 2>/dev/null | jq -r '.branches[] | [.name, (.needsRebase|tostring), (.isCurrent|tostring), (.pr.state // ""), (.pr.url // ""), ((.pr.number // "")|tostring)] | @tsv')"

  if [ -z "$rows" ]; then
    abort "No stack data found. Run this inside a gh-stack branch."
    return 1
  fi

  local max_branch_width=0
  local name needs is_current pr_state pr_url pr_number arrow needs_color pr_url_color pr_label pr_link_open pr_link_close

  while IFS=$'\t' read -r name needs is_current pr_state pr_url pr_number; do
    if (( ${#name} > max_branch_width )); then
      max_branch_width=${#name}
    fi
  done <<< "$rows"

  while IFS=$'\t' read -r name needs is_current pr_state pr_url pr_number; do
    arrow='  '
    [ "$is_current" = "true" ] && arrow='->'

    needs_color="$color_false"
    [ "$needs" = "true" ] && needs_color="$color_true"

    pr_url_color="$color_reset"
    [ "$pr_state" = "OPEN" ] && pr_url_color="$color_open"
    [ "$pr_state" = "DRAFT" ] && pr_url_color="$color_false"

    if [ -n "$pr_url" ] && [ -n "$pr_number" ]; then
      pr_label="#${pr_number}"
      pr_link_open=$'\033]8;;'"$pr_url"$'\a'
      pr_link_close=$'\033]8;;\a'

      if [ "$is_current" = "true" ]; then
        printf '%s %b%-*s%b  needs rebase: %b%-5s%b  %b%b%s%b%b\n' \
          "$arrow" "$color_current" "$max_branch_width" "$name" "$color_reset" "$needs_color" "$needs" "$color_reset" "$pr_url_color" "$pr_link_open" "$pr_label" "$pr_link_close" "$color_reset"
      else
        printf '%s %-*s  needs rebase: %b%-5s%b  %b%b%s%b%b\n' \
          "$arrow" "$max_branch_width" "$name" "$needs_color" "$needs" "$color_reset" "$pr_url_color" "$pr_link_open" "$pr_label" "$pr_link_close" "$color_reset"
      fi
    else
      if [ "$is_current" = "true" ]; then
        printf '%s %b%-*s%b  needs rebase: %b%-5s%b\n' \
          "$arrow" "$color_current" "$max_branch_width" "$name" "$color_reset" "$needs_color" "$needs" "$color_reset"
      else
        printf '%s %-*s  needs rebase: %b%-5s%b\n' \
          "$arrow" "$max_branch_width" "$name" "$needs_color" "$needs" "$color_reset"
      fi
    fi
  done <<< "$rows"
}

alias gsv='ghstackview'
