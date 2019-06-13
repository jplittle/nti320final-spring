#install, config  rsyslog client ##add to botom of every server script 
sudo yum -y update && yum -y install rsyslog
sudo systemctl start rsyslog
sudo systemctl enable rsyslog

echo "*.* @@rsyslog-server-final:514" >> /etc/rsyslog.conf

sudo firewall-cmd --permanent --add-port=514/udp
sudo firewall-cmd --permanent --add-port=514/tcp
sudo firewall-cmd --reload

sudo systemctl restart rsyslog