#!/bin/bash

 yum install epel-release -y

yum install python-pip python-devel gcc postgresql-server postgresql-devel postgresql-contrib -y

postgresql-setup initdb
systemctl start postgresql

sed -i.bak 's/ident/md5/g' /var/lib/pgsql/data/pg_hba.conf

systemctl restart postgresql
systemctl enable postgresql

echo "CREATE DATABASE myproject;
CREATE USER myprojectuser WITH PASSWORD 'password';
ALTER ROLE myprojectuser SET client_encoding TO 'utf8';
ALTER ROLE myprojectuser SET default_transaction_isolation TO 'read committed';
ALTER ROLE myprojectuser SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE myproject TO myprojectuser;" > /tmp/sqlfile.sql

sudo -i -u postgres psql -U postgres -f /tmp/sqlfile.sql

systemctl restart postgresql.service

systemctl status postgresql

yum install phpPgAdmin -y

sed -i.bak -e 's/Require local/ Require all granted/g' -e 's/Allow from 127.0.0.1/ Allow from all/g' /etc/httpd/conf.d/phpPgAdmin.conf

yum install -y httpd
systemctl enable httpd
systemctl start httpd

sudo -i -u postgres psql -U postgres -d template1 -c "ALTER USER postgres WITH PASSWORD 'postgres';"

sed -i "s,\$conf\['extra_login_security'\] = true;,\$conf\['extra_login_security'\] = false;,g" /etc/phpPgAdmin/config.inc.php

systemctl restart postgresql.service

sed -i.bak 's/peer/md5/g' /var/lib/pgsql/data/pg_hba.conf

systemctl restart postgresql.service
systemctl reload httpd

echo 'host    all             all             10.138.0.0/20            md5' >> /var/lib/pgsql/data/pg_hba.conf

sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /var/lib/pgsql/data/postgresql.conf

systemctl restart postgresql.service
systemctl reload httpd

setenforce 0

#install, config  rsyslog client ##add to botom of every server script 
sudo yum -y update && yum -y install rsyslog
sudo systemctl start rsyslog
sudo systemctl enable rsyslog

echo "*.* @@rsyslog-server-final:514" >> /etc/rsyslog.conf

sudo firewall-cmd --permanent --add-port=514/udp
sudo firewall-cmd --permanent --add-port=514/tcp
sudo firewall-cmd --reload

sudo systemctl restart rsyslog