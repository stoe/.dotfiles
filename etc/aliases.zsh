#!/bin/zsh

alias reload="clear && source ~/.zshrc"

# DOS style clear
alias cls="clear"

# speedtest
alias speedtest="wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test10.zip"

# flush DNS cache
alias flushdns="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;"

# delete thos .DS_Store files in style
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# empty all trashes
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"
