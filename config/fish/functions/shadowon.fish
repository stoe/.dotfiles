function shadowon --description 'Enable screenshot shadows'
    defaults write com.apple.screencapture disable-shadow -bool false
    killall SystemUIServer
end
