function shadowoff --description 'Disable screenshot shadows, translated from inc/aliases.zsh'
    defaults write com.apple.screencapture disable-shadow -bool true
    killall SystemUIServer
end
