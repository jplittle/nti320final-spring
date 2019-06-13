#!/bin/bash

#already has git installed
#Setup for final

##CLONE NEW REPO##
echo "CLONE NEW REPO"
git clone https://github.com/DFYT42/Linux-Automation-3/
sleep 30s

##SETTING PROJECT##
echo "SET PROJECT"
gcloud config set project nti-320-networkmonitoring

#Create nine instances
##REPO##
echo "REPO"
gcloud compute instances create nti320-final-repo-server \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-west1-b \
--private-network-ip=10.138.0.200 \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/home/g42dfyt/Linux-Automation-3/create_repos.sh
sleep 30s

##BUILD##
echo "BUILD"
gcloud compute instances create nti320-final-build-server \
--image-family centos-7 \
--image-project centos-cloud \
--boot-disk-size=50 \
--zone us-west1-b \
--private-network-ip=10.138.0.201 \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/home/g42dfyt/Linux-Automation-3/rpm_build.sh
sleep 30s

##NAGIOS##
echo "NAGIOS"
gcloud compute instances create nti320-final-nagios-server \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-west1-b \
--private-network-ip=10.138.0.202 \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/home/g42dfyt/Linux-Automation-3/nagios_install.sh
sleep 30s

##CACTI##
echo "CACTI"
gcloud compute instances create nti320-final-cacti-server \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-west1-b \
--private-network-ip=10.138.0.203 \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/home/g42dfyt/Linux-Automation-3/cacti_install.sh
sleep 30s

##LOGSERVER##
echo "LOGSERVER"
gcloud compute instances create nti320-final-logserver \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-west1-b \
--private-network-ip=10.138.0.204 \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/home/g42dfyt/Linux-Automation-2/ldap-rsyslog.sh
sleep 30s

##POSTGRES##
echo "POSTGRES"
gcloud compute instances create nti320-final-postgres \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-west1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/home/g42dfyt/Linux-Automation-2/postgres.sh
sleep 30s

##LDAPSERVER##
echo "LDAPSERVER"
gcloud compute instances create nti320-final-ldapserver \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-west1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/home/g42dfyt/Linux-Automation-2/ldap-server.sh
sleep 30s

##NFSSERVER##
echo "NFSSERVER"
gcloud compute instances create nti320-final-nfsserver \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-west1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/home/g42dfyt/Linux-Automation-2/nfs_server_automation.sh
sleep 30s

##DJANGOSERVER##
echo "DJANGOSERVER"
gcloud compute instances create nti320-final-django-the-j-is-silent-server \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-west1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/home/g42dfyt/Linux-Automation-2/ldap-django-postgres-migration.sh
sleep 30s

##CLIENTNFS##
#Ubuntu 1804 LTS#
echo "NFS CLIENT"
gcloud compute instances create nti320-final-nfs-client \
--image-family ubuntu-1804-lts \
--image-project ubuntu-os-cloud \
--zone us-west1-b \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/home/g42dfyt/Linux-Automation-2/nfs_client_automation.sh
sleep 30s

##CLIENTLDAP##
#Ubuntu 1804 LTS#
ECHO "LDAP CLIENT"
gcloud compute instances create nti320-final-ldap-client \
--image-family ubuntu-1804-lts \
--image-project ubuntu-os-cloud \
--zone us-west1-b \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=/home/g42dfyt/Linux-Automation-2/ldap-client-automation.sh

##ADD SERVERS TO NAGIOS MONITORING##
echo "INSTALLING NAGIOS FOR LOOP"
bash /home/g42dfyt/Linux-Automation-3/for_loop.sh
sleep 30s

echo "INSTALLING NRPE FOR LOOP"
bash /home/g42dfyt/Linux-Automation-3/for_loop_for_nrpe_install.sh
sleep 30s

##Not sure yet##
#bash /home/g42dfyt/Linux-Automation-3/for_loop_for_nrpe_install.sh
#sleep 30s
#nagios=( gcloud compute instances list | grep nti320-final-nagios-server | awk '{print $4}')
#sed -i "s/allowed_hosts=127.0.0.1, 10.168.15.196/allowed_hosts=127.0.0.1, $nagios/g" /home/g42dfyt/Linux-Automation-3/nagios-client-configuration.sh
#for servername in $( gcloud compute instances list | awk '{print $1}' | sed "1 d" | grep -v nti320-final-nagios-server );  do
#    gcloud compute scp --zone us-west1-b /home/g42dfyt/Linux-Automation-3/nagios-client-configuration.sh g42dfyt@$servername:/tmp/nagios-client-configuration.sh
#    gcloud compute ssh --zone us-west1-b g42dfyt@$servername --command='sudo bash /tmp/nagios-client-configuration.sh'
#done