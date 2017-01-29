#!/usr/bin/env bash

if ! [ -L /var/www ]; then
    rm -rf /var/www
    ln -fs /vagrant/remote /var/www
fi
apt-get update
apt-get -y install software-properties-common -q
apt-get -y install python-software-properties -q
### Install apache
apt-add-repository -y ppa:ondrej/apache2
apt-get update
apt-get install -y apache2
## Install git
apt-get install -y git
## Intall mysql
debconf-set-selections <<< 'mysql-server mysql-server/root_password password qweasd'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password qweasd'
apt-get -y install mysql-server
## mysql_secure_installation
### Install PHP7
apt-add-repository -y ppa:ondrej/php
apt-get update
apt-get install php7.0 php7.0-fpm php7.0-mysql php7.0-xml libapache2-mod-php7.0 php7.0-curl php7.0-sqlite php7.0-mcrypt php7.0-gd php-mbstring php7.0-xmlrpc -y
#apt-get install php7.0-xdebug -y
debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password qweasd'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password qweasd'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password qweasd'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect none'
apt-get -y install phpmyadmin > /dev/null 2>&1
cp -l /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
a2enmod authn_core
a2enmod proxy_fcgi setenvif
a2enmod mcrypt
a2enmod rewrite
a2enconf php7.0-fpm
a2enconf phpmyadmin
phpenmod mbstring
service apache2 stop
php -r '$cont = file_get_contents("/etc/apache2/apache2.conf"); file_put_contents("/etc/apache2/apache2.conf", preg_replace("/(<Directory \/var\/www\/>(.|\n)*AllowOverride )None/m","$1All",$cont));'
service apache2 start
