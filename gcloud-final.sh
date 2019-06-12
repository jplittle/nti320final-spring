#!/bin/bash

#git clone https://github.com/mnichols-github/NTI320final-spring.git

#1. rsyslog
gcloud compute instances create rsyslog-server-final \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-east1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=NTI310final/rsyslog-server-final.sh

#2 ldap
gcloud compute instances create ldap-server-final \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-east1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=NTI310final/ldap-server-final.sh

#3 #nfs
gcloud compute instances create nfs-server-final \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-east1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=NTI310final/nfs-server-final.sh

#4 postgres front
 gcloud compute instances create postgres-server-front-final \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-east1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=NTI310final/postgres-server-front-final.sh
      
#5 postgress back
gcloud compute instances create postgres-server-back-final \
--image-family centos-7 \
--image-project centos-cloud \
--zone us-east1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=NTI310final/postgres-server-back-final.sh
      
#6 ldap-nfs client - 1 
gcloud compute instances create ldap-nfs-client-01 \
--image-family ubuntu-1804-lts \
--image-project ubuntu-os-cloud \
--zone us-east1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=NTI310final/ldap-nfs-client.sh    

#7 ldap-nfs client- 2
gcloud compute instances create ldap-nfs-client-02 \
--image-family ubuntu-1804-lts \
--image-project ubuntu-os-cloud \
--zone us-east1-b \
--tags "http-server","https-server" \
--machine-type f1-micro \
--scopes cloud-platform \
--metadata-from-file startup-script=NTI310final/ldap-nfs-client.sh
