# DOS style clear
alias cls="clear"

# flush DNS cache
alias flushdns="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;"

# empty all trashes
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

alias allup="githubup; brewup; apm update"
alias allclean="emptytrash; cleanup; lsclean; lpclean; flushdns"


# AWS
alias aws-github.start="aws ec2 start-instances --instance-ids i-0d295c6866624bb6f i-0a8425c65d8d171a5"
alias aws-github.stop="aws ec2 stop-instances --instance-ids i-0d295c6866624bb6f i-0a8425c65d8d171a5"
