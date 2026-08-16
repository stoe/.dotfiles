function lpclean --description 'Clean up LaunchPad, translated from inc/aliases.zsh'
    defaults write com.apple.dock ResetLaunchPad -bool true
    killall Dock
end
