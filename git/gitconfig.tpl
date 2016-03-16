# .gitconfig

[hub]
    protocol = https

[user]
    name = AUTHORNAME
    email = AUTHOREMAIL

[gist]
    username = AUTHORNAME
    token = THAT_TOKEN_YOU_GOT

[filter "lfs"]
    required = true
    clean = git-lfs clean %f
    smudge = git-lfs smudge %f

[credential]
    helper = GIT_CREDENTIAL_HELPER

[color]
    diff = auto
    status = auto
    branch = auto
    ui = true

[color "branch"]
    current = yellow reverse
    local = yellow
    remote = green

[color "diff"]
    meta = yellow bold
    frag = magenta bold
    old = red bold
    new = green bold

[color "status"]
    added = green
    changed = yellow
    untracked = cyan

[core]
    # Use custom `.gitignore` and `.gitattributes`
    excludesfile = ~/.gitignore
    attributesfile = ~/.gitattributes
    editor = atom --wait
    autocrlf = input

[apply]
    whitespace = nowarn

[diff]
    tool = wstorm
[difftool]
    prompt = false
[difftool.wstorm]
    cmd = /usr/local/bin/wstorm diff "$LOCAL" "$REMOTE"

[merge]
    tool = wstorm
[mergetool]
    keepBackup = false
[mergetool.wstorm]
    cmd = /usr/local/bin/wstorm merge "$LOCAL" "$REMOTE" "$BASE" "$MERGED"
    trustExitCode = true

[help]
    autocorrect = 1

[push]
    # See `git help config` (search for push.default)
    # for more information on different options of the below setting.
    #
    # Setting to git 2.0 default to surpress warning message
    default = simple

# [alias]
#     # View abbreviated SHA, description, and history graph of the latest 20 commits
#     l = log --pretty=oneline -n 20 --graph --abbrev-commit
#     # View the current working tree status using the short format
#     s = status -s
#     # Show the diff between the latest commit and the current state
#     d = !"git diff-index --quiet HEAD -- || clear; git --no-pager diff --patch-with-stat"
#     # `git di $number` shows the diff between the state `$number` revisions ago and the current state
#     di = !"d() { git diff --patch-with-stat HEAD~$1; }; git diff-index --quiet HEAD -- || clear; d"
#     # Pull in remote changes for the current repository and all its submodules
#     p = !"git pull; git submodule foreach git pull origin master"
#     # Clone a repository including all submodules
#     c = clone --recursive
#     # Commit all changes
#     ca = !git add -A && git commit -av
#     # Switch to a branch, creating it if necessary
#     go = checkout -B
#     # Show verbose output about tags, branches or remotes
#     tags = tag -l
#     branches = branch -a
#     remotes = remote -v
#     # Credit an author on the latest commit
#     credit = "!f() { git commit --amend --author \"$1 <$2>\" -C HEAD; }; f"
#     # Interactive rebase with the given number of latest commits
#     reb = "!r() { git rebase -i HEAD~$1; }; r"
#     # Find branches containing commit
#     fb = "!f() { git branch -a --contains $1; }; f"
#     # Find tags containing commit
#     ft = "!f() { git describe --always --contains $1; }; f"
#     # Find commits by source code
#     fc = "!f() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short -S$1; }; f"
#     # Find commits by commit message
#     fm = "!f() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short --grep=$1; }; f"
#     # Remove branches that have already been merged with master
#     dm = "!git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d"
#     # fetch upstream changes (http://gitready.com/intermediate/2009/02/12/easily-fetching-upstream-changes.html)
#     pu = !"git fetch origin -v; git fetch upstream -v; git merge upstream/master"
