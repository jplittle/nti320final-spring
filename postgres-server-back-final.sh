#!/bin/bash

yum install -y epel-release

#install pip, which is the package manager for python
yum install  python-pip -y

#install virtualenv, which allows us to create a second python instance isololated from the system python
pip install virtualenv

#upgrade pip
pip install --upgrade pip

yum install -y telnet

#Create a project dir and cd into it
mkdir ~/myproject 
cd ~/myproject

#use virtualenv to create a new python install called myprojectenv, then activate that install of python
virtualenv myprojectenv
source myprojectenv/bin/activate

#install django and psycopg2 into myprojectenv
pip install django psycopg2-binary
django-admin.py startproject myproject .

chown -R mnicho18 . /opt/myproject

ex_ip=$( curl https://api.ipify.org )
sed -i "s/ALLOWED_HOSTS = \[\]/ALLOWED_HOSTS = \['"$ex_ip"'\]/g" /opt/myproject/myproject/settings.py

sed -i.bak '76,82d' /opt/myproject/myproject/settings.py

server_name=postgres-server-front-final

in_ip=$(getent hosts  $server_name$(echo .$(hostname -f |  cut -d "." -f2-)) | awk '{ print $1 }' )

echo "DATABASES = {
    'default':{
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'myproject',
        'USER': 'myprojectuser',
        'PASSWORD': 'password',
        'HOST': '$in_ip',
        'PORT': '5432',
    }
}" >> /opt/myproject/myproject/settings.py

python manage.py makemigrations
python manage.py migrate

echo "from django.contrib.auth.models import User; User.objects.filter(email='root@example.com').delete(); User.objects.create_superuser('root', 'root@example.com', 'password')" | python manage.py shell

source /opt/myproject/myprojectenv/bin/activate && python /opt/myproject/manage.py runserver 0.0.0.0:8000&

#install, config  rsyslog client ##add to botom of every server script 
sudo yum -y update && yum -y install rsyslog
sudo systemctl start rsyslog
sudo systemctl enable rsyslog

echo "*.* @@rsyslog-server-final:514" >> /etc/rsyslog.conf

sudo firewall-cmd --permanent --add-port=514/udp
sudo firewall-cmd --permanent --add-port=514/tcp
sudo firewall-cmd --reload

sudo systemctl restart rsyslog

