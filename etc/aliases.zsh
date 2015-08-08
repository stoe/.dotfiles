#!/usr/bin/env zsh

alias reload="clear && source ~/.zshrc"

# delete thos .DS_Store files in style
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# DOS style clear
alias cls="clear"

alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

alias speedtest="wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test10.zip"

# sencha cmd plus
alias sc="cmd-plus"
