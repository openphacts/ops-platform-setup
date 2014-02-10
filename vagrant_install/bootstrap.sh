#!/usr/bin/env bash

rm /var/lib/apt/lists/* -vf
apt-get update
apt-get install -y apache2
apt-get install -y php5 memcached php5-memcached php5-memcache php5-curl
a2enmod rewrite
sudo service apache2 restart

apt-get install -y git

#Install Linked Data API
sudo mkdir /var/www
cd /var/www
sudo git clone https://github.com/openphacts/OPS_LinkedDataApi -b meta_calls html
sudo sed -i 's,/var/www,/var/www/html,' /etc/apache2/sites-available/default
cat /etc/apache2/sites-available/default | tr "\n" "|" | sed 's,\(<Directory /var/www/html/>[^<]*\)AllowOverride None\([^<]*</Directory>\),\1AllowOverride All\2,' | sed 's/|/\n/g' >~/temp
sudo mv ~/temp /etc/apache2/sites-available/default
sudo mkdir /var/www/html/logs
sudo chmod 777 /var/www/html/logs
sudo mkdir /var/www/html/cache
sudo chmod 777 /var/www/html/cache
sudo chown -R vagrant:vagrant /var/www/html
sudo service apache2 restart

#Install IMS
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'
sudo apt-get install -y mysql-server-5.5 
sudo apt-get install -y tomcat7

cd /home/vagrant
sudo git clone https://github.com/openphacts/deployment.git deployment
sudo cp deployment/IMSandExpander/Ops1.3.1/QueryExpander.war /var/lib/tomcat7/webapps
sudo chown tomcat7:tomcat7 /var/lib/tomcat7/webapps/QueryExpander.war

mysql -uroot -ppassword test <./deployment/IMSandExpander/Ops1.3/mysqlConfig.sql
mysql -uroot -ppassword ims <./deployment/IMSandExpander/Ops1.3.1/imsMin.sql

sudo service tomcat7 start

#Install Virtuoso RDF Store

sudo debconf-set-selections <<<  'virtuoso-opensource-6.1 virtuoso-opensource-6.1/dba-password password dba'
sudo debconf-set-selections <<<  'virtuoso-opensource-6.1 virtuoso-opensource-6.1/dba-password-again password dba'
sudo apt-get install -y virtuoso-opensource
