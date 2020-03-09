# Use `hub` as our git wrapper:
#   http://defunkt.github.com/hub/
hub_path=$(which hub)
if (( $+commands[hub] )); then
  alias git=$hub_path
fi

# Reload the shell
alias reload!='. ~/.zshrc'

# Limit `ping` to 5
alias ping='ping -c 5'

# Only show TL;DR relevant to OSX
alias tldr='tldr -p osx'

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# DOS style clear
alias cls="clear"

# Empty the Trash on all mounted volumes and the main HDD.
# Also, clear Apple’s System Logs to improve shell startup speed.
# Finally, clear download history from quarantine. https://mths.be/bum
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lsclean="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# Clean up LaunchPad
alias lpclean="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock;"

# Flush Directory Service cache
alias flushdns="dscacheutil -flushcache && killall -HUP mDNSResponder"

# GitHub Professional Services PDFify
alias ghpdf="pdfify --header ~/private/xify-old/pdfify-node/assets/header.hbs --style ~/private/xify-old/pdfify-node/assets/style.css"

# Pipe my public key to my clipboard.
alias pubkey-stoe="more ~/.ssh/id_rsa_stoe.pub | pbcopy | echo '=> stoe public key copied to pasteboard'"
alias pubkey-git="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> GitHub public key copied to pasteboard'"
alias pubkey="pubkey-stoe"

# npm
alias npmla="npm la --depth=0"
alias npmll="npm ll --depth=0"
alias npmls="npm ls --depth=0"

# https://www.martin-brennan.com/set-timezone-from-terminal-osx/
alias settz="sudo systemsetup -settimezone $@"
