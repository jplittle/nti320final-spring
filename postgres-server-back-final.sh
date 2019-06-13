#!/bin/bash

#install pip, which is the package manager for python
yum install -y python-pip

#install virtualenv, which allows us to create a second python instance isololated from the system python
pip install virtualenv

#upgrade pip
pip install --upgrade pip

#Create a project dir and cd into it
mkdir ~/myproject 
cd ~/myproject

#use virtualenv to create a new python install called myprojectenv, then activate that install of python
virtualenv myprojectenv
source myprojectenv/bin/activate

#install django and psycopg2 into myprojectenv
pip install django psycopg2
django-admin.py startproject myproject .

python manage.py makemigrations
python manage.py migrate

wget -O /myproject/myproject/settings.py https://raw.githubusercontent.com/mnichols-github/nti320final-spring/master/settings.py

#install, config  rsyslog client ##add to botom of every server script 
sudo yum -y update && yum -y install rsyslog
sudo systemctl start rsyslog
sudo systemctl enable rsyslog

echo "*.* @@rsyslog-server-final:514" >> /etc/rsyslog.conf

sudo firewall-cmd --permanent --add-port=514/udp
sudo firewall-cmd --permanent --add-port=514/tcp
sudo firewall-cmd --reload

sudo systemctl restart rsyslog

