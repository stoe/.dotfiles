function shadowoff --description 'Disable screenshot shadows'
    defaults write com.apple.screencapture disable-shadow -bool true
    killall SystemUIServer
end
