#!/usr/bin/env bash

rm /var/lib/apt/lists/* -vf
apt-get update
apt-get install -y apache2
apt-get install -y php5 memcached php5-memcached php5-memcache
a2enmod rewrite
sudo service apache2 restart

apt-get install -y git
cd /var/www
sudo git clone https://github.com/openphacts/OPS_LinkedDataApi -b develop html
sudo sed -i 's,/var/www,/var/www/html,' /etc/apache2/sites-available/default
sudo mkdir /var/www/html/logs
sudo mkdir /var/www/html/cache
sudo service apache2 restart
