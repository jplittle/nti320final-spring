#!/bin/bash
if [ -e /etc/ldap.secret]; then

exit 0;

fi
#install git------------------------------------
yum install -y git
#change directory----------------------------
cd /tmp
#clone repository-------------------------------
git clone https://github.com/mnichols-github/NTI310final.git
#install ldap server and ldap client------------------------------
yum -y install openldap-servers
yum -y install openldap-clients
#copy db_config.example to ladp library as DB_CONGIG----------------
cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG 
#change copy ownership ldap------------------
chown ldap. /var/lib/ldap/DB_CONFIG
#enable ldap daemon-------------------------
systemctl enable slapd
#start ldap daemon---------------------------
systemctl start slapd
#install http server daemon------------------
yum -y install httpd
#install admin for php ladap-----------------
yum -y install phpldapadmin
#set SElinux state of httpd------------------
setsebool -P httpd_can_connect_ldap on
#enable httpd-------------------------------
systemctl enable httpd
#start httpd--------------------------------
systemctl start httpd
sed -i 's,Require local,#Require local\n Require all granted,g' /etc/httpd/conf.d/phpldapadmin.conf
#unalias copy command-----------------------
unalias cp
#create backup config.php
cp /etc/phpldapadmin/config.php /etc/phpldapadmin/config.php.orig
#copy config.php to phpldapadmin.conf-------
cp /tmp/NTI310final/config.php /etc/phpldapadmin/config.php
#change ownership of config.php-------------
chown ldap:apache /etc/phpldapadmin/config.php
#change to tmp directory
cd /tmp
#restart httpd.service----------------------
systemctl restart httpd.service
#create varalbe------------------------------
newsecret=P@ssw0rd1
#define vaiable------------------------------
newhash=$(slappasswd -s "$newsecret")
#store variable------------------------------
echo -n "$newsecret" > /root/ldap_admin_pass
#change permission of variable---------------
chmod 0600 /root/ldap_admin_pass
echo -e "dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcSuffix
olcSuffix: dc=nti310,dc=local
\n
dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcRootDN
olcRootDN: cn=ldapadm,dc=nti310,dc=local
\n
dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: $newhash" >> db.ldif
ldapmodify -Y EXTERNAL  -H ldapi:/// -f db.ldif
# Restrict auth---------------------
echo 'dn: olcDatabase={1}monitor,cn=config
changetype: modify
replace: olcAccess
olcAccess: {0}to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external, cn=auth" read by dn.base="cn=ldapadm,dc=nti310,dc=local" read by * none' > monitor.ldif
ldapmodify -Y EXTERNAL  -H ldapi:/// -f monitor.ldif
# Generate certs-------------------------------------------
openssl req -new -x509 -nodes -out /etc/openldap/certs/nti310ldapcert.pem -keyout /etc/openldap/certs/nti310ldapkey.pem -days 365 -subj "/C=US/ST=WA/L=Seattle/O=SCC/OU=IT/CN=nti310.local"
chown -R ldap. /etc/openldap/certs/nti*.pem
# Use Certs in LDAP----------------------------------------
echo -e "dn: cn=config
changetype: modify
replace: olcTLSCertificateKeyFile
olcTLSCertificateKeyFile: /etc/openldap/certs/nti310ldapkey.pem
\n
dn: cn=config
changetype: modify
replace: olcTLSCertificateFile
olcTLSCertificateFile: /etc/openldap/certs/nti310ldapcert.pem" > certs.ldif
ldapmodify -Y EXTERNAL -H ldapi:/// -f certs.ldif
#adding schema templates
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif 
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif
# Create base group and people structure----------------
#create domain ldap manager account---------------
echo -e "dn: dc=nti310,dc=local
dc: nti310
objectClass: top
objectClass: domain
\n
dn: cn=ldapadm ,dc=nti310,dc=local
objectClass: organizationalRole
cn: ldapadm
description: LDAP Manager
\n
#create main Group Group------------------
dn: ou=Group,dc=nti310,dc=local
objectClass: organizationalUnit
ou: Group
\n
#create child Group-A---------------------------
dn: cn=Group-A,ou=Group,dc=nti310,dc=local
cn: Group-A
gidnumber: 500
objectclass: posixGroup
objectclass: top
\n
#create child Group-B-------------------------
dn: cn=Group-B,ou=Group,dc=nti310,dc=local
cn: Group-B
gidnumber: 501
objectclass: posixGroup
objectclass: top
\n
#create main Group People---------------------
dn: ou=People,dc=nti310,dc=local
objectClass: organizationalUnit
ou: People
\n
#create child People <users>------------------
dn: cn=name-0 lname-0,ou=People,dc=nti310,dc=local
cn: name-0 lname-0
gidnumber: 500
givenname: name-0
homedirectory: /home/users/name-0
loginshell: /bin/sh
objectclass: inetOrgPerson
objectclass: posixAccount
objectclass: top
sn: lname-0
uid: name-0
uidnumber: 1000
userpassword: {SHA}8qEvGH67cIC9darJFgIU5rHkn30=
\n
dn: cn=name-1 lname-1,ou=People,dc=nti310,dc=local
cn: name-1 lname-1
gidnumber: 500
givenname: name-1
homedirectory: /home/users/name-1
loginshell: /bin/sh
objectclass: inetOrgPerson
objectclass: posixAccount
objectclass: top
sn: lname-1
uid: name-1
uidnumber: 1001
userpassword: {SHA}W6ph5Mm5Pz8GgiULbPgzG37mj9g=
\n
dn: cn=name-2 lname-2,ou=People,dc=nti310,dc=local
cn: name-2 lname-2
gidnumber: 500
givenname: name-2
homedirectory: /home/users/name-2
loginshell: /bin/sh
objectclass: inetOrgPerson
objectclass: posixAccount
objectclass: top
sn: lname-2
uid: name-2
uidnumber: 1002
userpassword: {SHA}W6ph5Mm5Pz8GgiULbPgzG37mj9g=
\n
dn: cn=name-3 lname-3,ou=People,dc=nti310,dc=local
cn: name-3 lname-3
gidnumber: 500
givenname: name-3
homedirectory: /home/users/name-3
loginshell: /bin/sh
objectclass: inetOrgPerson
objectclass: posixAccount
objectclass: top
sn: lname-3
uid: name-3
uidnumber: 1003
userpassword: {SHA}W6ph5Mm5Pz8GgiULbPgzG37mj9g=
\n
dn: cn=name-4 lname-4,ou=People,dc=nti310,dc=local
cn: name-4 lname-4
gidnumber: 500
givenname: name-4
homedirectory: /home/users/name-4
loginshell: /bin/sh
objectclass: inetOrgPerson
objectclass: posixAccount
objectclass: top
sn: lname-4
uid: name-4
uidnumber: 1004
userpassword: {SHA}W6ph5Mm5Pz8GgiULbPgzG37mj9g=
\n
dn: cn=name-5 lname-5,ou=People,dc=nti310,dc=local
cn: name-5 lname-5
gidnumber: 500
givenname: name-5
homedirectory: /home/users/name-5
loginshell: /bin/sh
objectclass: inetOrgPerson
objectclass: posixAccount
objectclass: top
sn: lname-5
uid: name-5
uidnumber: 1005
userpassword: {SHA}W6ph5Mm5Pz8GgiULbPgzG37mj9g=" > base.ldif
#temporary change - sets SElinux to permissive mode
setenforce 0
#set ldap simple auth, prompt for simple auth, bind DN to ldap dir for SASL auth
ldapadd -x -W -D "cn=ldapadm,dc=nti310,dc=local" -f base.ldif -y /root/ldap_admin_pass
#restart httpd
systemctl restart httpd
#install, config  rsyslog client
sudo yum -y update && yum -y install rsyslog
sudo systemctl start rsyslog
sudo systemctl enable rsyslog
echo "*.* @@rsyslog-server-final:514" >> /etc/rsyslog.conf
sudo firewall-cmd --permanent --add-port=514/udp
sudo firewall-cmd --permanent --add-port=514/tcp
sudo firewall-cmd --reload
sudo systemctl restart rsyslog
