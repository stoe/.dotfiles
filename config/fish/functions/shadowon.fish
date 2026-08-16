function shadowon --description 'Enable screenshot shadows, translated from inc/aliases.zsh'
    defaults write com.apple.screencapture disable-shadow -bool false
    killall SystemUIServer
end
