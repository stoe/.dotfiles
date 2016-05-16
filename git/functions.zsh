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
