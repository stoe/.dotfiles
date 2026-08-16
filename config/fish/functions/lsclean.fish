function lsclean --description 'Clean up LaunchServices duplicates in the “Open With” menu, translated from inc/aliases.zsh'
    /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
    and killall Finder
end
