#!/usr/bin/env bash

rm /var/lib/apt/lists/* -vf
apt-get update
apt-get install -y apache2
apt-get install -y php5 memcached php5-memcached php5-memcache php5-curl
a2enmod rewrite
sudo service apache2 restart

apt-get install -y git

#Install Linked Data API
sudo mkdir -p /var/www
cd /var/www
sudo git clone https://github.com/openphacts/OPS_LinkedDataApi -b meta_calls html
sudo sed -i 's,/var/www,/var/www/html,' /etc/apache2/sites-available/default
cat /etc/apache2/sites-available/default | tr "\n" "|" | sed 's,\(<Directory /var/www/html/>[^<]*\)AllowOverride None\([^<]*</Directory>\),\1AllowOverride All\2,' | sed 's/|/\n/g' >~/temp
sudo mv ~/temp /etc/apache2/sites-available/default
sudo mkdir /var/www/html/logs
sudo chmod 777 /var/www/html/logs
sudo mkdir /var/www/html/cache
sudo chmod 777 /var/www/html/cache
sudo chown -R www-data:vagrant /var/www/html
sudo chown -R vagrant:vagrant /var/www/html/.git
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

#Loading script dependencies
sudo apt-get install -y curl php5-cli unzip bzip2

#prefer more RAM over swap
sudo sysctl -w vm.swappiness=10 
sudo swapoff -a
sudo swapon -a
echo "vm.swappiness = 10" | sudo tee -a /etc/sysctl.conf

cd /home/vagrant
sudo apt-get install -y autoconf automake libtool flex bison gperf gawk m4 make openssl libssl-dev
git clone https://github.com/openlink/virtuoso-opensource.git -b stable/7 virtuoso7
cd virtuoso7
./autogen.sh
export CFLAGS="-O2 -m64"
VIRT_INSTALATION_PATH="/usr/local/virtuoso-opensource"
sudo ./configure --prefix=$VIRT_INSTALATION_PATH
make && sudo make install
PATH=$PATH:"$VIRT_INSTALATION_PATH/bin"
echo "export PATH=$PATH" >>/home/vagrant/.bashrc
echo "export VIRT_INSTALATION_PATH=$VIRT_INSTALATION_PATH" >>/home/vagrant/.bashrc

echo "export PATH=$PATH" >>/vagrant/env.sh #used by the loading script to setup env variables
echo "export VIRT_INSTALATION_PATH=$VIRT_INSTALATION_PATH" >>/vagrant/env.sh

#set NumberOfBuffers and MaxDirtyBuffers parameters in Virtuoso.ini
totalMem=$(cat /proc/meminfo | grep "MemTotal" | grep -o "[0-9]*")

virtMemAlloc=$(($totalMem/2))
nBuffers=$(($virtMemAlloc/9))
dirtyBuffers=$(($nBuffers*3/4))

echo "Virtuoso params: NumberOfBuffers $nBuffers ; MaxDirtyBuffers: $dirtyBuffers "

sudo sed -i "s/^\(NumberOfBuffers\s*= \)[0-9]*/\1$nBuffers/" $VIRT_INSTALATION_PATH/var/lib/virtuoso/db/virtuoso.ini
sudo sed -i "s/^\(MaxDirtyBuffers\s*= \)[0-9]*/\1$dirtyBuffers/" $VIRT_INSTALATION_PATH/var/lib/virtuoso/db/virtuoso.ini

#Setup Data directory
export DATA_DIR="$1"
echo "export DATA_DIR=$DATA_DIR" >>/home/vagrant/.bashrc
mkdir -p $DATA_DIR

mkdir -p /home/www-data
sudo chown -R www-data:vagrant /home/www-data
echo "export DATA_DIR=/home/www-data" >>/vagrant/env.sh
echo "export SCRIPTS_PATH=/var/www/html/scripts" >>/vagrant/env.sh

sudo sed -i "s%^\(DirsAllowed.*\)$%\1,$DATA_DIR%" $VIRT_INSTALATION_PATH/var/lib/virtuoso/db/virtuoso.ini
sudo sed -i "s%^\(DirsAllowed.*\)$%\1,/home/www-data%" $VIRT_INSTALATION_PATH/var/lib/virtuoso/db/virtuoso.ini


#start Virtuoso
cd $VIRT_INSTALATION_PATH/var/lib/virtuoso/db
$VIRT_INSTALATION_PATH/bin/virtuoso-t +wait

sleep 60 #wait for Virtuoso to bootup
isql 1111 dba dba VERBOSE=OFF BANNER=OFF PROMPT=OFF ECHO=OFF BLOBS=ON ERRORS=stdout "exec=GRANT EXECUTE  ON DB.DBA.SPARQL_INSERT_DICT_CONTENT TO \"SPARQL\";"
isql 1111 dba dba VERBOSE=OFF BANNER=OFF PROMPT=OFF ECHO=OFF BLOBS=ON ERRORS=stdout "exec=GRANT EXECUTE  ON DB.DBA.L_O_LOOK TO \"SPARQL\";"
isql 1111 dba dba VERBOSE=OFF BANNER=OFF PROMPT=OFF ECHO=OFF BLOBS=ON ERRORS=stdout "exec=GRANT EXECUTE  ON DB.DBA.SPARUL_RUN TO \"SPARQL\";"
isql 1111 dba dba VERBOSE=OFF BANNER=OFF PROMPT=OFF ECHO=OFF BLOBS=ON ERRORS=stdout "exec=GRANT EXECUTE  ON DB.DBA.SPARQL_DELETE_DICT_CONTENT TO \"SPARQL\";"
isql 1111 dba dba VERBOSE=OFF BANNER=OFF PROMPT=OFF ECHO=OFF BLOBS=ON ERRORS=stdout "exec=GRANT EXECUTE  ON DB.DBA.RDF_OBJ_ADD_KEYWORD_FOR_GRAPH TO \"SPARQL\";"

