#!/bin/bash
# based off of https://www.tecmint.com/configure-ldap-client-to-connect-external-authentication
# with some additions that make it work, as opposed to not work

if [ -e /mnt/nfsclient ];
    then
        exit 0;
fi

#refresh repos
apt-get update

#install, config debconf
apt-get install -y debconf-utils
export DEBIAN_FRONTEND=noninteractive
apt-get --yes install libnss-ldap libpam-ldap ldap-utils nscd
unset DEBIAN_FRONTEND

echo "ldap-auth-config ldap-auth-config/bindpw password
nslcd nslcd/ldap-bindpw password
ldap-auth-config ldap-auth-config/rootbindpw password
ldap-auth-config ldap-auth-config/move-to-debconf boolean true
nslcd nslcd/ldap-sasl-krb5-ccname string /var/run/nslcd/nslcd.tkt
nslcd nslcd/ldap-starttls boolean false
libpam-runtime libpam-runtime/profiles multiselect unix, ldap, systemd, capability
nslcd nslcd/ldap-sasl-authzid string
ldap-auth-config ldap-auth-config/rootbinddn string cn=ldapadm,dc=nti320,dc=local
#nslcd nslcd/ldap-uris string ldap://<ldap server name>
nslcd nslcd/ldap-uris string ldap://ldap-server-fianl
nslcd nslcd/ldap-reqcert select
nslcd nslcd/ldap-sasl-secprops string
ldap-auth-config ldap-auth-config/ldapns/ldap_version select 3
ldap-auth-config ldap-auth-config/binddn string cn=proxyuser,dc=example,dc=net
nslcd nslcd/ldap-auth-type select none
nslcd nslcd/ldap-cacertfile string /etc/ssl/certs/ca-certificates.crt
nslcd nslcd/ldap-sasl-realm string
ldap-auth-config ldap-auth-config/dbrootlogin boolean true
ldap-auth-config ldap-auth-config/override boolean true
nslcd nslcd/ldap-base string dc=nti320,dc=local
ldap-auth-config ldap-auth-config/pam_password select md5
nslcd nslcd/ldap-sasl-mech select
nslcd nslcd/ldap-sasl-authcid string
ldap-auth-config ldap-auth-config/ldapns/base-dn string dc=nti320,dc=local
#ldap-auth-config ldap-auth-config/ldapns/ldap-server string ldap://<ldap server name>
ldap-auth-config ldap-auth-config/ldapns/ldap-server string ldap://ldap-server-final/
nslcd nslcd/ldap-binddn string
ldap-auth-config ldap-auth-config/dblogin boolean false" >> tempfile

#pipe to tempfile for automation
while read line; do echo "$line" | debconf-set-selections; done < tempfile

echo "P@ssw0rd1" > /etc/ldap.secret

#change read write by root only
chown 0600 /etc/ldap.secret

#config client to use ldap
sudo auth-client-config -t nss -p lac_ldap

#removes password requirement for su
echo "account sufficient pam_succeed_if.so uid = 0 use_uid quiet" >> /etc/pam.d/su

sed -i 's/base dc=example,dc=net/base dc=nti320,dc=local/g' /etc/ldap.conf

#sed -i 's,uri ldapi:///,uri ldap://<ldap server name>/,g' /etc/ldap.conf
sed -i 's,uri ldapi:///,uri ldap://ldap-server-final/,g' /etc/ldap.conf

sed -i 's/rootbinddn cn=manager,dc=example,dc=net/rootbinddn cn=ldapadm,dc=nti320,dc=local/g' /etc/ldap.conf

systemctl restart nscd
systemctl enable nscd

#install NFS client
sudo apt-get install -y nfs-client
systemctl enable rpcbind
systemctl start rpcbind
mkdir /mnt/nfsclient

echo "nfs-server-final:/root/nfsshare/     /mnt/nfsclient       nfs     rw,sync,hard,intr 0 0" >> /etc/fstab

mount -a

sudo reboot