#!/bin/zsh

# ------------------------------------------------------------------------------
#
# Setup PHP 5.6, MySQL, phpMyAdmin and nginx on OS X Yosemite
# (tested on 10.10.5)
#
# thanks to
# http://blog.frd.mn/install-nginx-php-fpm-mysql-and-phpmyadmin-on-os-x-mavericks-using-homebrew/
# for the inspiration
#
# TODO phpmyadmin `pma`
# TODO phpmyadmin `config.inc.php`
#
# ------------------------------------------------------------------------------

source "$HOME/.dotfiles/inc/helpers.sh"

# DISABLED ---------------------------------------------------------------------
disabled

clear
echo

TMP_DIR="$HOME/scratch/php-mysql-nginx-config"
CODE_ROOT_DIR="$HOME/private"
GIST_ROOT_DIR="https://gist.githubusercontent.com/stoe/b0c10b29a2ce9ce0ec3b"

PHPMYADMIN_VERSION_NO="4.6.2"
PHPMYADMIN_VERSION="phpMyAdmin-${PHPMYADMIN_VERSION_NO}-all-languages"

print -P "installing %F{3}Nginx, PHP-FPM, MySQL and phpMyAdmin%f"
print -P "%F{8}inspired by http://blog.frd.mn/install-nginx-php-fpm-mysql-and-phpmyadmin-on-os-x-mavericks-using-homebrew/"

# Make sure we have the $HOME/Library/LaunchAgents directory.
[ ! -d "$HOME/Library/LaunchAgents" ]   && formatexec "mkdir -p $HOME/Library/LaunchAgents"

if type brew | grep "not found" > /dev/null 2>&1 ; then
    section "brew" "required"
else
    # Create server root.
    if [ ! -d "/var/www" ]; then
        formatexec "sudo mkdir -p /var/www"
        formatexec "sudo chown :staff /var/www"
        formatexec "sudo chmod 775 /var/www"
    fi

    # Symlink /var/www -> $HOME/www.
    test -h "$HOME/www" || formatexec "ln -s /var/www/ $HOME/www"

    # Create TMP_DIR.
    if [ ! -d "$TMP_DIR" ]; then
        formatexec "mkdir -p $TMP_DIR"
        formatexec "sudo chown :staff $TMP_DIR"
        formatexec "sudo chmod 775 $TMP_DIR"
    fi

    # Symlink /var/www -> $HOME/www.
    test -h "$HOME/www" || formatexec "ln -s /var/www/ $HOME/www"

    section "brew" # -----------------------------------------------------------

    formatexec "brew doctor"
    formatexec "brew update"

    [ ! $(brew tap | grep homebrew/dupes) ] && formatexec "brew tap homebrew/dupes"
    [ ! $(brew tap | grep homebrew/php) ]   && formatexec "brew tap homebrew/php"

    ok

    section "PHP-FPM" # --------------------------------------------------------

    if [ ! $(brew list | grep ^php56$) ]; then
        # Install PHP-FPM (download and compile).
        formatexec "brew install --without-apache --with-fpm --with-mysql php56"

        # install PEAR if not available first
        if type pear | grep "not found" > /dev/null 2>&1 ; then
          print -P "\n%F{1}pear%f missing\n"
          echo
          print -P "install it\n"
          print -P "%F{3}> curl -L --silent https://pear.php.net/go-pear.phar -o $TMP_DIR/go-pear.phar%f"
          print -P "%F{3}> php -d detect_unicode=0 $TMP_DIR/go-pear.phar%f"
          echo
          print -P "Options:"
          print -P "1. %F{3} /usr/local/etc/pear%f"
          print -P "4. %F{3} /usr/local/bin%f"

          abort
        fi

        # PEAR permissions.
        formatexec "chmod -R ug+w /usr/local/Cellar/php56/5.6.22/lib/php"
        formatexec "pear config-set php_ini /usr/local/etc/php/5.6/php.ini system"

        # Setup auto start ...
        if [ ! -f "~/Library/LaunchAgents/homebrew.mxcl.php56.plist" ]; then
            formatexec "ln -sfv /usr/local/opt/php56/homebrew.mxcl.php56.plist ~/Library/LaunchAgents/"
            formatexec "sudo chown root:wheel ~/Library/LaunchAgents/homebrew.mxcl.php56.plist"
        fi

        # ... and start ...
        formatexec "launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.php56.plist"

        # ... and test.
        formatexec "lsof -Pni4 | grep LISTEN | grep php"
        # php-fpm   57469 stoe    6u  IPv4 0xc441e8cc5b86720d      0t0  TCP 127.0.0.1:9000 (LISTEN)
        # php-fpm   57477 stoe    0u  IPv4 0xc441e8cc5b86720d      0t0  TCP 127.0.0.1:9000 (LISTEN)
        # php-fpm   57478 stoe    0u  IPv4 0xc441e8cc5b86720d      0t0  TCP 127.0.0.1:9000 (LISTEN)
        # php-fpm   57479 stoe    0u  IPv4 0xc441e8cc5b86720d      0t0  TCP 127.0.0.1:9000 (LISTEN)
    fi

    ok "$(brew --prefix php56)"

    section "MySQL" # ----------------------------------------------------------

    if [ ! $(brew list | grep mysql) ]; then
        # Install MySQL.
        formatexec "brew install mysql"

        # Setup auto start ...
        if [ ! -f "~/Library/LaunchAgents/homebrew.mxcl.mysql.plist" ]; then
            formatexec "ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents"
        fi

        # ... and start.
        formatexec "launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"

        print -P "run the following two separately:"
        print -P "  1. %F{3}mysql_secure_installation%f to secure the installation"
        # > Enter current password for root (enter for none):
        # > Change the root password? [Y/n]
        # > Remove anonymous users? [Y/n]
        # > Disallow root login remotely? [Y/n]
        # > Remove test database and access to it? [Y/n]
        # > Reload privilege tables now? [Y/n]
        print -P "  2. %F{3}mysql -uroot -p%f to test"
        print -P "  quit MySQL prompt with: %F{3}> \\\q%f"
        # mysql> \q
        # Bye
    fi

    ok "$(brew --prefix mysql)"

    section "phpMyAdmin" # -----------------------------------------------------

    if test -h "$HOME/www/phpmyadmin"; then
        # Install autoconf.
        if [ ! $(brew list | grep autoconf) ]; then
            formatexec "brew install autoconf"
        fi

        # Set $PHP_AUTOCONF.
        if type $(which autoconf) | grep "not found" > /dev/null 2>&1 ; then
            print -P "\n%F{1}autoconf%f missing\n"
            echo
            print -P "\ninstall it\n"
            print -P "add %F{3}PHP_AUTOCONF=\"\'\$(which autoconf)\'\"%f to %F{3}~/.zshrc%f first"

            abort
        else
            print -P "%F{8}> $(which autoconf)%f"
        fi

        # Install phpMyAdmin.
        formatexec "curl -L --silent https://files.phpmyadmin.net/phpMyAdmin/$PHPMYADMIN_VERSION_NO/$PHPMYADMIN_VERSION.tar.gz -o /tmp/$PHPMYADMIN_VERSION.tar.gz" \
            && formatexec "tar xC $HOME/www -f /tmp/$PHPMYADMIN_VERSION.tar.gz" \
            && formatexec "mv $HOME/www/$PHPMYADMIN_VERSION $HOME/www/phpmyadmin" \
            && formatexec "rm /tmp/$PHPMYADMIN_VERSION.tar.gz"

        # Create storage tables.
        formatexec "mysql-uroot -p < $HOME/www/phpmyadmin/sql/create_tables.sql"
    fi

    ok "$HOME/www/phpmyadmin"

    section "nginx" # ----------------------------------------------------------

    if [ ! $(brew list | grep nginx) ]; then
        # Download setup.
        formatexec "git clone -q $GIST_ROOT_DIR.git $TMP_DIR/"

        # Install nginx.
        formatexec "brew install nginx"

        # Buff the limit for nginx.
        ulimit -n 1024

        # Remember the password for a bit.
        formatexec "sudo -v"

        # Setup auto start ...
        if [ ! -f "/Library/LaunchDaemons/homebrew.mxcl.nginx.plist" ]; then
            formatexec "sudo cp -v /usr/local/opt/nginx/*.plist /Library/LaunchDaemons/"
            formatexec "sudo chown root:wheel /Library/LaunchDaemons/homebrew.mxcl.nginx.plist"
        fi

        # ... and start ...
        formatexec "sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.nginx.plist"
        formatexec "sleep 3" # wait ...

        # ... and test ...
        formatexec "curl -IL http://127.0.0.1:8080"
        # HTTP/1.1 200 OK
        # Server: nginx/1.8.0
        # Date: Sun, 16 Aug 2015 04:37:48 GMT
        # Content-Type: text/html
        # Content-Length: 612
        # Last-Modified: Sat, 08 Aug 2015 16:10:17 GMT
        # Connection: keep-alive
        # ETag: "55c629e9-264"
        # Accept-Ranges: bytes

        # ... and stop
        formatexec "sudo launchctl unload /Library/LaunchDaemons/homebrew.mxcl.nginx.plist"
        formatexec "sleep 2" # wait ...

        # nginx.conf (create directories if needed)
        [ ! -d "/usr/local/etc/nginx/logs" ]            && formatexec "mkdir -p /usr/local/etc/nginx/logs"
        [ ! -d "/usr/local/etc/nginx/sites-available" ] && formatexec "mkdir -p /usr/local/etc/nginx/sites-available"
        [ ! -d "/usr/local/etc/nginx/sites-enabled" ]   && formatexec "mkdir -p /usr/local/etc/nginx/sites-enabled"
        [ ! -d "/usr/local/etc/nginx/conf".d ]          && formatexec "mkdir -p /usr/local/etc/nginx/conf.d"
        [ ! -d "/usr/local/etc/nginx/ssl" ]             && formatexec "mkdir -p /usr/local/etc/nginx/ssl"

        # Symlink nginx home /usr/local/etc/nginx -> $CODE_ROOT_DIR/nginx
        test -h "$CODE_ROOT_DIR/nginx" || ln -s "/usr/local/etc/nginx" "$CODE_ROOT_DIR/nginx"

        # Delete and replace current default nginx.conf
        [ -f "/usr/local/etc/nginx/nginx.conf" ] && formatexec "rm /usr/local/etc/nginx/nginx.conf"
        formatexec "mv $TMP_DIR/nginx.conf /usr/local/etc/nginx/nginx.conf"

        # Load PHP FPM.
        [ -f "/usr/local/etc/nginx/conf.d/php-fpm" ] && formatexec "rm /usr/local/etc/nginx/conf.d/php-fpm"
        formatexec "mv $TMP_DIR/php-fpm /usr/local/etc/nginx/conf.d/php-fpm"

        # Virtual hosts.
        formatexec "mv $TMP_DIR/sites-available_default     /usr/local/etc/nginx/sites-available/default"
        formatexec "mv $TMP_DIR/sites-available_default-ssl /usr/local/etc/nginx/sites-available/default-ssl"
        formatexec "mv $TMP_DIR/sites-available_phpmyadmin  /usr/local/etc/nginx/sites-available/phpmyadmin"

        formatexec "sudo chown :staff /var/www"
        formatexec "sudo chmod 775 /var/www"

        formatexec "mv $TMP_DIR/*.html /var/www"

        formatexec "sudo chown :staff /var/www"
        formatexec "sudo chmod 775 /var/www"

        # Setup SSL
         [ ! -d "/usr/local/etc/nginx/ssl" ] && formatexec "mkdir -p /usr/local/etc/nginx/ssl"

        if [ -d "/usr/local/etc/nginx/ssl/" ]; then
            #  [ ! -f "/usr/local/etc/nginx/ssl/localhost.crt" ]  && openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=State/L=Town/O=Office/CN=localhost" -keyout /usr/local/etc/nginx/ssl/localhost.key -out /usr/local/etc/nginx/ssl/localhost.crt
             [ ! -f "/usr/local/etc/nginx/ssl/local.dev.crt" ]  && openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=State/L=Town/O=Office/CN=local.dev" -keyout /usr/local/etc/nginx/ssl/local.dev.key -out /usr/local/etc/nginx/ssl/local.dev.crt
             [ ! -f "/usr/local/etc/nginx/ssl/phpmyadmin.crt" ] && openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=State/L=Town/O=Office/CN=phpmyadmin" -keyout /usr/local/etc/nginx/ssl/phpmyadmin.key -out /usr/local/etc/nginx/ssl/phpmyadmin.crt
         fi

        # Enable virtual hosts
        if [ -d "/usr/local/etc/nginx/sites-available/" ]; then
            formatexec "ln -sfv /usr/local/etc/nginx/sites-available/default        /usr/local/etc/nginx/sites-enabled/default"
            formatexec "ln -sfv /usr/local/etc/nginx/sites-available/default-ssl    /usr/local/etc/nginx/sites-enabled/default-ssl"
            formatexec "ln -sfv /usr/local/etc/nginx/sites-available/phpmyadmin     /usr/local/etc/nginx/sites-enabled/phpmyadmin"
        fi

        # Start ngnix
        formatexec "sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.nginx.plist"
    fi

    ok "$(brew --prefix nginx)"

    # Clean up.
    formatexec "rm -rf $TMP_DIR"
fi

# DONE & RELOAD ----------------------------------------------------------------
finished
