#!/bin/bash

#git clone https://github.com/mnichols-github/nti320final-spring.git

#echo "SET PROJECT"
#gcloud config set project nti-320-networkmonitoring

#rsyslog
gcloud compute instances create rsyslog-server-final \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-west1-b \
--private-network-ip=10.138.0.204 \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=nti320final-spring/rsyslog-server-final.sh
sleep 30s

#repo
gcloud compute instances create repo-server-final \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-west1-b \
--private-network-ip=10.138.0.200 \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=nti320final-spring/repo-server-final.sh
sleep 30s

#rpm
gcloud compute instances rpm-build-server-final \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-west1-b \
--private-network-ip=10.138.0.201 \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=nti320final-spring/rpm-build-server-final.sh
sleep 30s

#nagios
gcloud compute instances nagios-server-final \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-west1-b \
--private-network-ip=10.138.0.202 \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=nti320final-spring/nagios-server-final.sh
sleep 30s

#cacti
gcloud compute instances cacti-server-final \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-west1-b \
--private-network-ip=10.138.0.203 \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=nti320final-spring/cacti-server-final.sh
sleep 30s

#ldap
gcloud compute instances create ldap-server-final \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-west1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=nti320final-spring/ldap-server-final.sh
sleep 30s

#nfs
gcloud compute instances create nfs-server-final \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-west1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=nti320final-spring/nfs-server-final.sh
sleep 30s

#postgres front
 gcloud compute instances create postgres-server-front-final \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-west1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=nti320final-spring/postgres-server-front-final.sh
 sleep 30s
     
#postgress back
gcloud compute instances create postgres-server-back-final \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-west1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=nti320final-spring/postgres-server-back-final.sh
sleep 30s
      
#ldap-nfs client - 1 
gcloud compute instances create ldap-nfs-client-01 \
--image-family ubuntu-1804-lts \
--image-project ubuntu-os-cloud \
--zone us-west1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=nti320final-spring/ldap-nfs-client.sh    
sleep 30s

#ldap-nfs client- 2
gcloud compute instances create ldap-nfs-client-02 \
--image-family ubuntu-1804-lts \
--image-project ubuntu-os-cloud \
--zone us-west1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=nti320final-spring/ldap-nfs-client.sh
sleep 30s

bash /nti320final-spring/for_loop.sh
sleep 30s

bash /nti320final-spring/for_loop_for_nrpe.sh
sleep 30s
