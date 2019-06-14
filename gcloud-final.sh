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

#rpm
gcloud compute instances create rpm-build-server-final \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-west1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=nti320final-spring/rpm-build-server-final.sh

#nagios
gcloud compute instances create nagios-server-final \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-west1-b \
--private-network-ip=10.138.0.202 \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=nti320final-spring/nagios-server-final.sh

#cacti
gcloud compute instances create cacti-server-final \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-west1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=nti320final-spring/cacti-server-final.sh

#ldap
gcloud compute instances create ldap-server-final \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-west1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=nti320final-spring/ldap-server-final.sh

#nfs
gcloud compute instances create nfs-server-final \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-west1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=nti320final-spring/nfs-server-final.sh

#postgres front
gcloud compute instances create postgres-server-front-final \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-west1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=nti320final-spring/postgres-server-front-final.sh
     
#postgress back
gcloud compute instances create postgres-server-back-final \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-west1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=nti320final-spring/postgres-server-back-final.sh

#ldap-nfs client - 1 
gcloud compute instances create ldap-nfs-client-01 \
--image-family ubuntu-1804-lts \
--image-project ubuntu-os-cloud \
--zone us-west1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=nti320final-spring/ldap-nfs-client.sh    

#ldap-nfs client- 2
gcloud compute instances create ldap-nfs-client-02 \
--image-family ubuntu-1804-lts \
--image-project ubuntu-os-cloud \
--zone us-west1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=nti320final-spring/ldap-nfs-client.sh
