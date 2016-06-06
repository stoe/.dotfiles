#!/bin/zsh

if brew list | grep "nginx" > /dev/null 2>&1 ; then
    alias nginx.start='sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.nginx.plist'
    alias nginx.stop='sudo launchctl unload /Library/LaunchDaemons/homebrew.mxcl.nginx.plist'
    alias nginx.restart='nginx.stop && nginx.start'
    alias php-fpm.start="launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.php56.plist"
    alias php-fpm.stop="launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.php56.plist"
    alias php-fpm.restart='php-fpm.stop && php-fpm.start'
    alias mysql.start="launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"
    alias mysql.stop="launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"
    alias mysql.restart='mysql.stop && mysql.start'
    alias nginx.logs.error='tail -250f /usr/local/etc/nginx/logs/error.log'
    alias nginx.logs.access='tail -250f /usr/local/etc/nginx/logs/access.log'
    alias nginx.logs.default.access='tail -250f /usr/local/etc/nginx/logs/default.access.log'
    alias nginx.logs.default-ssl.access='tail -250f /usr/local/etc/nginx/logs/default-ssl.access.log'
    alias nginx.logs.phpmyadmin.error='tail -250f /usr/local/etc/nginx/logs/phpmyadmin.error.log'
    alias nginx.logs.phpmyadmin.access='tail -250f /usr/local/etc/nginx/logs/phpmyadmin.access.log'

    alias all.start="nginx.start && php-fpm.start && mysql.start"
    alias all.stop="nginx.stop && php-fpm.stop && mysql.stop"
    alias all.restart="nginx.restart && php-fpm.restart && mysql.restart"
fi
