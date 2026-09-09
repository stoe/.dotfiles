function lpclean --description 'Clean up LaunchPad'
    defaults write com.apple.dock ResetLaunchPad -bool true
    killall Dock
end
