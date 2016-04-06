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

[gpg]
	program = gpg

[commit]
	gpgsign = false

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

[alias]
  # View abbreviated SHA, description, and history graph of the latest 20 commits
  l = log --pretty=oneline -n 20 --graph --abbrev-commit
  # View the current working tree status using the short format
  s = status -s
  # Show verbose output about tags, branches or remotes
  tags = tag -l
  branches = branch -a
  remotes = remote -v
  # Remove branches that have already been merged with master
  dm = "!git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d"
