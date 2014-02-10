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

#sudo debconf-set-selections <<<  'virtuoso-opensource-6.1 virtuoso-opensource-6.1/dba-password password dba'
#sudo debconf-set-selections <<<  'virtuoso-opensource-6.1 virtuoso-opensource-6.1/dba-password-again password dba'
#sudo apt-get install -y virtuoso-opensource

cd /home/vagrant
sudo apt-get install -y autoconf automake libtool flex bison gperf gawk m4 make openssl libssl-dev
git clone https://github.com/openlink/virtuoso-opensource.git -b stable/7 virtuoso7
cd virtuoso7
./autogen.sh
export CFLAGS="-O2 -m64"
./configure --prefix=/usr/local/virtuoso-opensource
make && sudo make install
export PATH=$PATH:/usr/local/virtuoso-opensource/bin
cd /usr/local/virtuoso-opensource/var/lib/virtuoso/db
virtuoso-t -f &

isql 1111 dba dba VERBOSE=OFF BANNER=OFF PROMPT=OFF ECHO=OFF BLOBS=ON ERRORS=stdout "exec=GRANT EXECUTE  ON DB.DBA.SPARQL_INSERT_DICT_CONTENT TO \"SPARQL\";"
isql 1111 dba dba VERBOSE=OFF BANNER=OFF PROMPT=OFF ECHO=OFF BLOBS=ON ERRORS=stdout "exec=GRANT EXECUTE  ON DB.DBA.L_O_LOOK TO \"SPARQL\";"
isql 1111 dba dba VERBOSE=OFF BANNER=OFF PROMPT=OFF ECHO=OFF BLOBS=ON ERRORS=stdout "exec=GRANT EXECUTE  ON DB.DBA.SPARUL_RUN TO \"SPARQL\";"
isql 1111 dba dba VERBOSE=OFF BANNER=OFF PROMPT=OFF ECHO=OFF BLOBS=ON ERRORS=stdout "exec=GRANT EXECUTE  ON DB.DBA.SPARQL_DELETE_DICT_CONTENT TO \"SPARQL\";"
isql 1111 dba dba VERBOSE=OFF BANNER=OFF PROMPT=OFF ECHO=OFF BLOBS=ON ERRORS=stdout "exec=GRANT EXECUTE  ON DB.DBA.RDF_OBJ_ADD_KEYWORD_FOR_GRAPH TO \"SPARQL\";"

#Loading
sudo apt-get install -y curl php5-cli unzip bunzip2
#Add data directory to DirsAllowed clause in virtuoso.ini



