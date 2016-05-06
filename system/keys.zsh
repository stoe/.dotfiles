# Pipe my public key to my clipboard.
alias pubkey-stoe="more ~/.ssh/id_rsa_stoe.pub | pbcopy | echo '=> stoe public key copied to pasteboard'"
alias pubkey-git="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> GitHub public key copied to pasteboard'"
alias pubkey="pubkey-stoe"
