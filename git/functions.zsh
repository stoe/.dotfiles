# open in gittower.app
function gt() {
    if [ $# -eq 0 ]; then
        # no arguments opens current directory
        gittower .
    else
        # otherwise opens the given location
        gittower "$@"
    fi
}

# Git Be
# Will contact the GitHub API to retrieve name and email information about a user
# and uses that data to change the local (repo-scoped) configuration for user.name and user.email
#
# Usage: gitbe githubteacher
# https://gist.github.com/loranallensmith/0350db8a91578f40e471d322cf244d45

function gitbe {
    echo "Looking up $1 on GitHub.com..."
    data=$(curl -s https://api.github.com/users/$1)
    name=$(echo $data | grep name\": | sed 's/  \"name\": \"\(.*\)\",/\1/')
    email=$(echo $data | grep email\": | sed 's/  \"email\": \"\(.*\)\",/\1/')
    git config --local user.name "$name"
    git config --local user.email $email
    echo "Your local configuration has been modified."
    echo "You are now committing as: $name <$email>."
}

# Usage: git-ci-add-status <sha>
function git-ci-add-status {

  if [[ ! -z "$1" && ! -z "$2" ]]; then
    section "pending"

    curl -H "Authorization: token ${STOE_SCRIPT_TOKEN}" \
      "https://api.github.com/repos/$2/statuses/$1" \
      -d '{"state": "pending", "target_url": "https://github.com", "description": "example pending", "context": "demo statuses pending"}'

    section "failure"

    curl -H "Authorization: token ${STOE_SCRIPT_TOKEN}" \
      "https://api.github.com/repos/$2/statuses/$1" \
      -d '{"state": "failure", "target_url": "https://github.com", "description": "example failure", "context": "demo statuses failure"}'

    section "success"

    curl -H "Authorization: token ${STOE_SCRIPT_TOKEN}" \
      "https://api.github.com/repos/$2/statuses/$1" \
      -d '{"state": "success", "target_url": "https://github.com", "description": "example success", "context": "demo statuses success"}'

    ok
  else
    echo "Usage: $0 <sha1> <user/rept>"
  fi

}

# update all work folders
function githubup {
  local _pwd=$(pwd)
  local SERVICES_HOME="$HOME/github"

  clear

  # use global var `export GITHUB_PERSONAL_WORK_FOLDERS="..."`
  _folders=(${=GITHUB_PERSONAL_WORK_FOLDERS})

  # repositories w/ gh-pages as the default branch
  _ghpages=('services-web training-on-demand')

  for _folder in ${_folders}; do
    local _dir="${SERVICES_HOME}/${_folder}"
    local _branch="master"

    if [ -d ${_dir} ]; then
      section "${_folder}"
      echo

      cd "${_dir}"

      if [[ " ${_ghpages[@]} " =~ " ${_folder} " ]]; then
          _branch="gh-pages"
      fi

      formatexec "git checkout ${_branch} && git pull"
      echo
      formatexec "git bclean ${_branch}"
      echo
    fi
  done

  cd ${_pwd}

  unset _folders
  unset _folder
  unset _ghpages
  unset _branch
  unset _dir
  unset _pwd
}
