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
  curl -H "Authorization: token ${CICD_DEMO_TOKEN}" \
    "https://api.github.com/repos/${CICD_DEMO_URL}/statuses/$1" \
    -d '{"state": "pending", "target_url": "https://google.com", "description": "example", "context": "demo statuses pending"}'

  curl -H "Authorization: token ${CICD_DEMO_TOKEN}" \
    "https://api.github.com/repos/${CICD_DEMO_URL}/statuses/$1" \
    -d '{"state": "failure", "target_url": "https://google.com", "description": "example", "context": "demo statuses failure"}'
}

# update all work folders
function githubup {
  local _PWD=$(pwd)
  local SERVICES_HOME="$HOME/github"

  clear

  # use global var `export GITHUB_PERSONAL_WORK_FOLDERS="..."`
  folders=(${=GITHUB_PERSONAL_WORK_FOLDERS})
  # repositories where gh-pages is the default branch
  ghpages=('training-web')

  for folder in ${folders}; do
    local DIR="${SERVICES_HOME}/${folder}"
    local _branch="master"

    if [ -d ${DIR} ]; then
      section "${folder}"

      cd "${DIR}"

      formatexec "git pull"

      if [[ " ${ghpages[@]} " =~ " ${folder} " ]]; then
          _branch="gh-pages"
      fi

      formatexec "git bclean ${_branch}"
      echo
    fi
  done

  unset folders
  unset folder
  unset DIR

  cd ${_PWD}
}
