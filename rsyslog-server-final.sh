#!/bin/bash
#get updates and install rsyslog server
sudo yum -y update && yum install -y rsyslog 
#start rsyslog
sudo systemctl start rsyslog
sudo systemctl enable rsyslog
#backup
cp /etc/rsyslog.conf /etc/rsyslog.conf.back
#need sed statement
#vim /etc/rsyslog.conf
sed -i 's/#$InputTCPServerRun 514/$InputTCPServerRun 514/g' /etc/rsyslog.conf
sed -i 's/#$UDPServerRun 514/$UDPServerRun 514/g' /etc/rsyslog.conf
sed -i 's/#$ModLoad imudp/$ModLoad imudp/g' /etc/rsyslog.conf
sed -i 's/#$ModLoad imtcp/$ModLoad imtcp/g' /etc/rsyslog.conf
echo '$template RemoteLogs,"/var/log/%HOSTNAME%/%PROGRAMNAME%.log"
*.* ?RemoteLogs 
& ~' >> /etc/rsyslog.conf
#config firewall
sudo firewall-cmd --permanent --add-port=514/udp
sudo firewall-cmd --permanent --add-port=514/tcp
sudo firewall-cmd --reload
#restart rsyslog
sudo systemctl restart rsyslog