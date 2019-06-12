#!/bin/bash

#how to check 
#systemctl status rpcbind
#systemctl status nfs-server
#systemctl status rpc-statd
#systemctl status nfs-idmapd

#install nfs-utils
yum install -y nfs-utils libnfsidmap

#create directories
mkdir /root/nfsshare
mkdir /root/nfsshare/devstuff
mkdir /root/nfsshare/testing
mkdir /root/nfsshare/home_dirs

#change access presmissions
chmod 777 /root/nfsshare/

#config exports
echo "/root/nfsshare *(rw,sync,no_root_squash)
/root/nfsshare/devstuff *(rw,sync,no_root_squash)
/root/nfsshare/testing *(rw,sync,no_root_squash)
/root/nfsshare/home_dirs *(rw,sync,no_root_squash)" >> /etc/exports

#config firewall
sudo firewall-cmd --permanent --zone public --add-service mountd
sudo firewall-cmd --permanent --zone public --add-service rpc-bind
sudo firewall-cmd --permanent --zone public --add-service nfs
sudo firewall-cmd --reload

#restart server
sudo systemctl restart nfs-server

#enble services to ports binding (symlink)
systemctl enable rpcbind
#link to systems copy of "nfs-server"
systemctl enable nfs-server
#link to system copy of "nfs-lock"
#systemctl enable nfs-lock
#link to system copy of "nfs-idmap"
#systemctl enable nfs-idmap
#start services
systemctl start rpcbind
systemctl start nfs-server
systemctl start rpc-statd 
systemctl start nfs-idmapd

#install, config  rsyslog client ##add to botom of every server script 
sudo yum -y update && yum -y install rsyslog
sudo systemctl start rsyslog
sudo systemctl enable rsyslog
echo "*.* @@rsyslog-server-final:514" >> /etc/rsyslog.conf
sudo firewall-cmd --permanent --add-port=514/udp
sudo firewall-cmd --permanent --add-port=514/tcp
sudo firewall-cmd --reload
sudo systemctl restart rsyslog
sudo systemctl restart nfs-server
sudo systemctl restart rsyslog